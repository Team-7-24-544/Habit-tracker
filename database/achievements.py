import logging

from fastapi import HTTPException
from sqlalchemy import select, desc
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session
from fastapi.responses import JSONResponse

from models import Achievement, UserAchievement

logger = logging.getLogger(__name__)


async def get_last_10_achievements(user_id: int, db: Session):
    logger.info(f"Getting last 10 achievements for user {user_id}")
    try:
        stmt = (
            select(Achievement.name, Achievement.description)
            .join(UserAchievement, Achievement.id == UserAchievement.achievement_id)
            .where(UserAchievement.user_id == user_id)
            .order_by(desc(UserAchievement.date_achieved))
            .limit(10)
        )
        results = db.execute(stmt).fetchall()

        achievements = [{"name": row.name, "description": row.description} for row in results]
        return JSONResponse(content={"answer": "success", "achievements": achievements},
                            media_type="application/json; charset=utf-8")
    except IntegrityError as e:
        logger.error(f"Error fetching achievements for user '{user_id}': {e.detail}")
        raise HTTPException(status_code=400, detail={"answer": "Error fetching achievements"})
    except Exception as e:
        db.rollback()
        logger.error(f"Unexpected error fetching achievements for user '{user_id}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))
