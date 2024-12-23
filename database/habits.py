import json
import logging
from datetime import date

from fastapi import HTTPException
from sqlalchemy import select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from models import HabitTemplate
from models import Habit, HabitTracking
from fastapi.responses import JSONResponse

logger = logging.getLogger(__name__)


async def add_habit(user_id: int, name: str, description: str, time_table: str, db: Session):
    try:
        new_habit_id = create_habit(name, description, time_table, db)
        connect_user_habit(user_id, new_habit_id, db)
        return JSONResponse(content={"answer": "success"})
    except HTTPException as e:
        logger.error(f"Error creating habit '{name}': {e.detail}")
        raise e
    except Exception as e:
        logger.error(f"Unexpected error creating habit '{name}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


def connect_user_habit(user_id: int, habit_id: int, db: Session):
    new_habit = HabitTracking(user_id=user_id, habit_id=habit_id, date=date.today(), monthly_schedule=json.dumps("{}"))
    try:
        db.add(new_habit)
        db.commit()
        db.refresh(new_habit)
    except IntegrityError as e:
        logger.error(f"Error creating habit '{habit_id}': {str(e)}")
        return HTTPException(status_code=500, detail=str(e))
    except Exception as e:
        logger.error(f"Unexpected error creating habit '{habit_id}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


def create_habit(name: str, description: str, time_table: str, db: Session):
    days = json.loads(time_table)
    for day in ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']:
        if day not in days:
            days[day] = json.loads('{}')
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


async def get_templates(db: Session):
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
            result["body"][str(template.id)] = {"name": template.name, "description": template.description, "time_table": time_table}
        return JSONResponse(content=result, media_type="application/json; charset=utf-8")
    except IntegrityError as e:
        logger.error(f"Error getting templates of habits: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
    except Exception as e:
        logger.error(f"Unexpected error getting templates of habits: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


async def get_template_by_id(habit_id: int, db: Session):
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

