import logging

from fastapi import HTTPException
from fastapi.responses import JSONResponse
from sqlalchemy import select, desc
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from achievement_checks import *
from bot_message import add_message
from models import Achievement, UserAchievement, Habit

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


checks = {
    "all": [
        streak_check,
    ],
    "not_habit": [
        unique_habits,
    ],
    "habit": {
        "Veeeeryyy looooooooooooooong naaaameeee": [
            check1,
        ],
    }
}


def update_achieves(user_id, habit_id, db):
    achievements = checks
    habit = db.query(Habit).where(Habit.id == habit_id).first()
    if habit.name in achievements['habit'].keys():
        for check in achievements['habit'][habit.name]:
            achievement_id = check(user_id, habit_id, db)
            if achievement_id:
                add_achievement(achievement_id, user_id, db)
    for check in achievements['all']:
        achievement_id = check(user_id, habit_id, db)
        if achievement_id:
            add_achievement(achievement_id, user_id, db)


def update_all_achieves(user_id, habit_id, db):
    achievements = checks
    for check in achievements['not_habit']:
        achievement_id = check(user_id, habit_id, db)
        if achievement_id:
            add_achievement(achievement_id, user_id, db)


def add_achievement(achievement_id: int, user_id: int, db: Session):
    if db.query(UserAchievement).where(
            and_(UserAchievement.achievement_id == achievement_id, UserAchievement.user_id == user_id)).first():
        return
    today = datetime.today().strftime('%Y-%m-%d')
    user_achievement = UserAchievement(user_id=user_id, achievement_id=achievement_id, date_achieved=today)
    db.add(user_achievement)
    db.commit()
    achievement = db.query(Achievement).filter(Achievement.id == achievement_id).first()
    add_message(user_id, "Получено новое достижение! " + str(achievement.name), db)
