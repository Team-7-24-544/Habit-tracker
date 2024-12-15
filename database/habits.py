import logging
from fastapi import HTTPException
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session
from models import Habit
from fastapi.responses import JSONResponse

logger = logging.getLogger(__name__)


async def add_habit(name: str, description: str, time: str, week_days: str, duration: int, db: Session):
    try:
        new_habit = create_habit(name, description, time, week_days, duration, db)
        return JSONResponse(content={"answer": "success"})
    except HTTPException as e:
        logger.error(f"Error creating habit '{name}': {e.detail}")
        raise e
    except Exception as e:
        logger.error(f"Unexpected error creating habit '{name}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


def create_habit(name: str, description: str, time: str, week_days: str, duration: int, db: Session):
    new_habit = Habit(
        name=name,
        description=description,
        time=time,
        week_days=week_days,
        duration=duration,
        notifications=''
    )
    logger.info(f"Creating new habit: {name}, {description}, {time}, {week_days}, {duration}")

    db.add(new_habit)
    db.commit()
    db.refresh(new_habit)

    logger.info(f"New habit created successfully: {name}")
    return new_habit
