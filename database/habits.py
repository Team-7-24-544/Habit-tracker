import json
import logging
from datetime import date

from fastapi import HTTPException
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session
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


"""
http://127.0.0.1:8000/habits/create?name=new_habit&description=something&time_table={monday:{11:30:13:50}}
"""
