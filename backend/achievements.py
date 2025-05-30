"""
Глобальная логика проверки достижений
"""

from fastapi import HTTPException
from fastapi.responses import JSONResponse
from sqlalchemy import select, desc
from sqlalchemy.exc import IntegrityError

from achievement_checks import *
from bot_message import add_message
from models import Achievement, UserAchievement, Habit

logger = logging.getLogger("info_logger")
errors = logging.getLogger("error_logger")


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
        errors.error(f"Error fetching achievements for user '{user_id}': {e.detail}")
        raise HTTPException(status_code=400, detail={"answer": "Error fetching achievements"})
    except Exception as e:
        db.rollback()
        errors.error(f"Unexpected error fetching achievements for user '{user_id}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


UNIVERSAL_CHECK = "all"
SPECIAL_CHECK = "not_habit"
CUSTOM_CHECK = "custom"

checks = {
    UNIVERSAL_CHECK: [
        streak_check,
        total_check,
    ],
    CUSTOM_CHECK: {
        "Some habit": [
            some_custom_check,
            ...
        ],
    },
    SPECIAL_CHECK: [
        unique_habits,
        together,
    ],
}


def update_achieves(user_id, habit_id, db):
    achievements = checks
    habit = db.query(Habit).where(Habit.id == habit_id).first()
    if habit.name in achievements[CUSTOM_CHECK].keys():
        for check in achievements[CUSTOM_CHECK][habit.name]:
            achievement_id = check(user_id, habit_id, db)
            if achievement_id:
                add_achievement(achievement_id, user_id, db)
    else:
        for check in achievements[UNIVERSAL_CHECK]:
            achievement_id = check(user_id, habit_id, db)
            if achievement_id:
                add_achievement(achievement_id, user_id, db)


def update_all_achieves(user_id, habit_id, db):
    achievements = checks
    for check in achievements[SPECIAL_CHECK]:
        achievement_id = check(user_id, habit_id, db)
        if achievement_id:
            add_achievement(achievement_id, user_id, db)


def add_achievement(achievement_id: int, user_id: int, db: Session):
    try:
        if db.query(UserAchievement).where(
                and_(UserAchievement.achievement_id == achievement_id, UserAchievement.user_id == user_id)).first():
            return
        today = datetime.today().strftime('%Y-%m-%d')
        user_achievement = UserAchievement(user_id=user_id, achievement_id=achievement_id, date_achieved=today)
        db.add(user_achievement)
        db.commit()
        achievement = db.query(Achievement).filter(Achievement.id == achievement_id).first()
        add_message(user_id, "Получено новое достижение! " + str(achievement.name), db)
    except Exception as e:
        errors.error(f"Error adding achievement: {str(e)}")
