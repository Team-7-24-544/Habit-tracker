import logging
from datetime import date

from fastapi import HTTPException
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session
from fastapi.responses import JSONResponse

from models import MoodTracking

logger = logging.getLogger(__name__)


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
        db.rollback()
        logger.error(f"Error fetching emotions for user '{user_id}': {e.detail}")
        raise HTTPException(status_code=400, detail={"id": -1, "answer": "Error fetching emotions"})
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error fetching emotions for user '{user_id}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


async def set_emoji_for_day(user_id: int, emoji: int, db: Session):
    day = date.today().strftime('%Y-%m-%d')
    logger.info(f"Received request to set emoji {emoji} by {user_id}")
    try:
        existing_entry = db.query(MoodTracking).filter(MoodTracking.user_id == user_id,
                                                       MoodTracking.mood_date == day).first()
        if existing_entry:
            existing_entry.mood_value = emoji
        else:
            new_entry = MoodTracking(user_id=user_id, mood_date=day, mood_value=emoji)
            db.add(new_entry)

        db.commit()
        db.refresh(existing_entry if existing_entry else new_entry)

        logger.info(f"Successfully set emoji '{emoji}' for user {user_id} on {day}")
        return JSONResponse(content={"answer": "success", "body": {"days": {day: emoji}}})
    except HTTPException as e:
        db.rollback()
        logger.error(f"Error setting emoji for user {id} on {day}: {e.detail}")
        raise e

    except IntegrityError as e:
        db.rollback()
        logger.error(f"Error while setting emoji: {str(e)}")
        raise HTTPException(status_code=400, detail={"id": -1, "answer": "Error setting emoji"})

    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error setting emoji for user {user_id} on {day}: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
