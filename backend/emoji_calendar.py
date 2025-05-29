"""
Механизм работы с виджетом "календарь-эмоций"
"""

import logging
from datetime import date
from datetime import datetime

from fastapi import HTTPException
from fastapi.responses import JSONResponse
from sqlalchemy import or_
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from models import MoodTracking, HabitTracking

logger = logging.getLogger("info_logger")
errors = logging.getLogger("error_logger")


async def get_emotions(user_id: int, db: Session):
    logger.info("Received request to get emotions for %s", user_id)
    try:
        stmt = db.query(MoodTracking).filter(MoodTracking.user_id == user_id)
        emotions = stmt.all()
        days = {}
        for emotion in emotions:
            days[emotion.mood_date] = emotion.mood_value
        return JSONResponse(content={"answer": "success", "days": days})
    except IntegrityError as e:
        errors.error(f"Error fetching emotions for user '{user_id}': {e.detail}")
        raise HTTPException(status_code=400, detail={"id": -1, "answer": "Error fetching emotions"})
    except Exception as e:
        errors.error(f"Unexpected error fetching emotions for user '{user_id}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


async def set_emoji_for_day(user_id: int, emoji: int, db: Session):
    day = date.today().strftime('%Y-%m-%d')
    logger.info(f"Received request to set emoji {emoji} by {user_id}")
    try:
        existing_entry = db.query(MoodTracking).filter(MoodTracking.user_id == user_id,
                                                       MoodTracking.mood_date == day).first()
        if existing_entry:
            existing_entry.mood_value = emoji
            db.commit()
            db.refresh(existing_entry)
        else:
            new_entry = MoodTracking(user_id=user_id, mood_date=day, mood_value=emoji)
            db.add(new_entry)
            db.commit()
            db.refresh(new_entry)

        errors.info(f"Successfully set emoji '{emoji}' for user {user_id} on {day}")
        return JSONResponse(content={"answer": "success", "body": {"days": {day: emoji}}})
    except HTTPException as e:
        db.rollback()
        errors.error(f"Error setting emoji for user {id} on {day}: {e.detail}")
        raise e

    except IntegrityError as e:
        db.rollback()
        errors.error(f"Error while setting emoji: {str(e)}")
        raise HTTPException(status_code=400, detail={"id": -1, "answer": "Error setting emoji"})

    except Exception as e:
        db.rollback()
        errors.error(f"Unexpected error setting emoji for user {user_id} on {day}: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


async def get_habit_periods(user_id: int, db: Session):
    logger.info(f"Received request to get habit periods of user {user_id}")
    try:
        now = datetime.now()
        start_of_month = datetime(now.year, now.month, 1)
        start_of_month = start_of_month.strftime('%d-%m-%Y')
        habit_periods = db.query(HabitTracking).filter(
            HabitTracking.user_id == user_id,
            or_(
                HabitTracking.start >= str(start_of_month),
                HabitTracking.end >= str(start_of_month)
            )
        ).all()

        starts = []
        ends = []

        for habit in habit_periods:
            habit_start = habit.start if habit.start else None
            habit_end = habit.end if habit.end else None

            if habit_start and habit_start >= str(start_of_month):
                starts.append(habit.start)
            if habit_end and habit_end >= str(start_of_month):
                ends.append(habit.end)

        return JSONResponse(content={"answer": "success", "habit_periods": {"starts": starts, "ends": ends}})
    except Exception as e:
        errors.error(f"Error fetching habit periods for user_id {user_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
