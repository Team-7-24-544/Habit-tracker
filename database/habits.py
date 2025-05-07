import json
import logging
from datetime import date, datetime, timedelta
from operator import and_

from fastapi import HTTPException
from fastapi.responses import JSONResponse
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from achievements import update_achieves
from models import Habit, HabitTracking
from models import HabitTemplate

logger = logging.getLogger(__name__)


async def add_habit(user_id: int, name: str, description: str, time_table: str, db: Session) -> JSONResponse:
    logger.info(f"Received request to add new habit '{name}' for user {user_id}")
    try:
        new_habit_id = create_habit(name, description, time_table, db)
        connect_user_habit(user_id, new_habit_id, db)
        logger.info(f"Habit '{name}' (ID: {new_habit_id}) successfully added for user {user_id}")
        return JSONResponse(content={"answer": "success"})
    except HTTPException as e:
        logger.error(f"Error creating habit '{name}': {e.detail}")
        raise e
    except Exception as e:
        logger.error(f"Unexpected error creating habit '{name}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


def connect_user_habit(user_id: int, habit_id: int, db: Session) -> None:
    new_habit_tracking = HabitTracking(user_id=user_id, habit_id=habit_id, start=date.today().strftime("%d-%m-%Y"),
                                       monthly_schedule=json.dumps(dict()))
    try:
        db.add(new_habit_tracking)
        db.commit()
        db.refresh(new_habit_tracking)
    except IntegrityError as e:
        logger.error(f"Error creating habit '{habit_id}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
    except Exception as e:
        logger.error(f"Unexpected error creating habit '{habit_id}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


def create_habit(name: str, description: str, time_table: str, db: Session) -> int:
    days = json.loads(time_table)
    for day in ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']:
        if day not in days:
            days[day] = '{}'
    new_habit = Habit(
        name=name,
        description=description,
        monday=json.dumps(days['monday']),
        tuesday=json.dumps(days['tuesday']),
        wednesday=json.dumps(days['wednesday']),
        thursday=json.dumps(days['thursday']),
        friday=json.dumps(days['friday']),
        saturday=json.dumps(days['saturday']),
        sunday=json.dumps(days['sunday']),
    )
    logger.info(f"Creating new habit: {name}, {description}")

    db.add(new_habit)
    db.commit()
    db.refresh(new_habit)

    logger.info(f"New habit created successfully: {name}")
    return new_habit.id


async def get_templates(db: Session) -> JSONResponse:
    logger.info("Received request to get templates")
    try:
        stmt = select(HabitTemplate)
        templates = db.execute(stmt).scalars().all()
        result = {"answer": "success", "body": dict()}
        for template in templates:
            time_table = dict()
            time_table["monday"] = template.monday
            time_table["tuesday"] = template.tuesday
            time_table["wednesday"] = template.wednesday
            time_table["thursday"] = template.thursday
            time_table["friday"] = template.friday
            time_table["saturday"] = template.saturday
            time_table["sunday"] = template.sunday
            result["body"][str(template.id)] = {"name": template.name, "description": template.description,
                                                "time_table": time_table}
        return JSONResponse(content=result, media_type="application/json; charset=utf-8")
    except IntegrityError as e:
        logger.error(f"Error getting templates of habits: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
    except Exception as e:
        logger.error(f"Unexpected error getting templates of habits: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


async def get_template_by_id(habit_id: int, db: Session) -> JSONResponse:
    logger.info(f"Received request to get template of {habit_id}")
    try:
        stmt = select(HabitTemplate).where(HabitTemplate.id == habit_id)
        template = db.execute(stmt).scalars().first()
        result = {"answer": "success",
                  "name": template.name,
                  "description": template.description,
                  "monday": template.monday,
                  "tuesday": template.tuesday,
                  "wednesday": template.wednesday,
                  "thursday": template.thursday,
                  "friday": template.friday,
                  "saturday": template.saturday,
                  "sunday": template.sunday}
        return JSONResponse(content=result, media_type="application/json; charset=utf-8")
    except IntegrityError as e:
        logger.error(f"Error getting template of habit: {str(e)}")
    except Exception as e:
        logger.error(f"Unexpected error getting template of habit: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


def get_current_day() -> str:
    today = datetime.now().strftime("%A").lower()
    return getattr(Habit, today)


async def get_habits(user_id: int, db: Session) -> JSONResponse:
    logger.info(f"Received request to get habits of user {user_id}")
    try:
        today = datetime.now().strftime("%A").lower()

        result = db.query(Habit).join(HabitTracking, HabitTracking.habit_id == Habit.id).filter(
            HabitTracking.user_id == user_id,
        ).all()

        res = dict()
        for habit in result:
            habit_schedule = getattr(habit, today)
            habit_tracking = db.query(HabitTracking).where(
                HabitTracking.user_id == user_id,
                HabitTracking.habit_id == habit.id
            ).first()

            if habit_schedule != '{}':
                schedule_dict = json.loads(habit_schedule)
                uncompleted = dict()
                completed = dict()
                completed_today = dict()
                today_date = datetime.today().strftime("%d-%m-%Y")
                monthly_schedule = json.loads(habit_tracking.monthly_schedule)
                if today_date in monthly_schedule:
                    completed_today = monthly_schedule[today_date]
                for start_time, end_time in schedule_dict.items():
                    if start_time in completed_today:
                        completed[start_time] = end_time
                    else:
                        uncompleted[start_time] = end_time
                res[str(habit.id)] = {
                    'schedule': {'uncompleted': json.dumps(uncompleted), 'completed': json.dumps(completed)},
                    'name': habit.name,
                    'description': habit.description
                }

        return JSONResponse(content=res, media_type="application/json; charset=utf-8")

    except IntegrityError as e:
        logger.error(f"Error getting habits: {str(e)}")
    except Exception as e:
        logger.error(f"Unexpected error getting habits: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


def check_prev_mark(user_id: int, habit_id: int, db: Session) -> bool:
    habit = db.query(Habit).where(Habit.id == habit_id).first()

    completions = db.query(HabitTracking).where(
        and_(
            HabitTracking.user_id == user_id,
            HabitTracking.habit_id == habit_id
        )
    ).first()

    completions = json.loads(completions.monthly_schedule)
    if not completions:
        return False
    last_time = None
    days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    tuples = [(day, start, stop) for day in days for start, stop in json.loads(getattr(habit, day)).items()]
    for i in range(len(tuples)):
        if datetime.today().strftime("%A") == tuples[i][0] and datetime.now().strftime("%H:%M") < tuples[i][1]:
            if not last_time:
                last_time = tuples[-1]
            break
        last_time = tuples[i]
    if len(tuples) > 1:
        prev_day = datetime.today() - timedelta(
            days=days.index(last_time[0]) - days.index(datetime.today().strftime("%A").lower()))
    else:
        prev_day = datetime.today() - timedelta(days=7)
    if prev_day not in completions.keys():
        return False
    return last_time not in completions[prev_day]


async def set_mark(user_id: int, habit_id: int, db: Session):
    logger.info(f"Received request to set habit mark for user {user_id}")
    try:
        habit_tracking = db.query(HabitTracking).filter(
            HabitTracking.user_id == user_id,
            HabitTracking.habit_id == habit_id
        ).first()

        if not habit_tracking:
            logger.warning(f"Error: Habit {habit_id} not found for user {user_id}")
            raise HTTPException(status_code=404, detail="Habit not found")

        today = datetime.now().strftime("%d-%m-%Y")
        current_time = datetime.now().strftime("%H:%M")
        habit_schedule = db.query(Habit).filter(Habit.id == habit_id).first()
        daily_schedule = json.loads(getattr(habit_schedule, datetime.now().strftime("%A").lower()))
        current_period_start = None
        for start_time, end_time in daily_schedule.items():
            if datetime.strptime(start_time, "%H:%M") <= datetime.strptime(current_time, "%H:%M") <= datetime.strptime(
                    end_time, "%H:%M"):
                current_period_start = start_time
                break

        if not current_period_start:
            logger.warning(f"Current time {current_time} is not within any period for habit {habit_id}")
            raise HTTPException(status_code=400, detail="Current time is not within any scheduled period")

        completed_days = json.loads(str(habit_tracking.monthly_schedule))
        if not check_prev_mark(user_id, habit_id, db):
            habit_tracking.streak = 0
        if today not in completed_days or current_period_start not in completed_days[today]:
            if today in completed_days:
                completed_days[today].append(current_period_start)
            else:
                completed_days[today] = [current_period_start]

            habit_tracking.monthly_schedule = json.dumps(completed_days)
            habit_tracking.streak += 1
            db.commit()
            db.refresh(habit_tracking)
        update_achieves(user_id, habit_id, db)
        logger.info(f"Habit {habit_id} mark set successfully for user {user_id}")
        return JSONResponse(content={"answer": "success"})

    except HTTPException as e:
        logger.error(f"Failed to set mark for habit {habit_id} and user {user_id}: {e.detail}")
        raise e

    except Exception as e:
        logger.exception(f"Error while setting mark for habit {habit_id} and user {user_id}")
        raise HTTPException(status_code=500, detail=str(e))


async def get_all_habits(user_id: int, db: Session) -> JSONResponse:
    logger.info(f"Received request to get all habits of user {user_id}")
    try:
        result = db.query(Habit).join(HabitTracking, HabitTracking.habit_id == Habit.id).filter(
            HabitTracking.user_id == user_id,
        ).all()

        res = []
        for habit in result:
            res.append(
                {'id': str(habit.id),
                 'name': habit.name,
                 'description': habit.description}
            )

        return JSONResponse(content={'habits': res}, media_type="application/json; charset=utf-8")

    except IntegrityError as e:
        logger.error(f"Error getting all habits: {str(e)}")
    except Exception as e:
        logger.error(f"Unexpected error getting all habits: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
