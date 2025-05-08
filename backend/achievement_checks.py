import logging
from datetime import datetime

from sqlalchemy import and_, func

from models import HabitTracking, Achievement, Habit

logger = logging.getLogger("info_logger")
errors = logging.getLogger("error_logger")


def streak_check(user_id, habit_id, db):
    def next_streak(current_streak):
        if current_streak == 7:
            return 14
        if current_streak == 14:
            return 30
        return current_streak + 30

    streak = 1
    habit_tracking = db.query(HabitTracking).where(
        and_(HabitTracking.user_id == user_id, HabitTracking.habit_id == habit_id)).first()
    if habit_tracking is None:
        return
    while streak < habit_tracking.streak:
        streak = next_streak(streak)
    if streak == habit_tracking.streak:
        achievement = db.query(Achievement).where(
            and_(Achievement.habit_id == habit_id, Achievement.check_function == 'streak_check')).first()

        if achievement is None:
            habit = db.query(Habit).where(Habit.id == habit_id).first()
            achievement = Achievement(name='Стрик по привычке "' + habit.name + '"',
                                      description=f"выполнений подряд: {streak}", habit_id=habit_id,
                                      check_function='streak_check')
            db.add(achievement)
            db.commit()
            db.refresh(achievement)

        return achievement.id


def check1(user_id, habit_id, db):
    pass


def unique_habits(user_id, habit_id, db):
    pass


def running_100km_month_check(user_id, habit_id, db):
    today = datetime.now()
    total_distance = db.query(func.sum(HabitTracking.value)).where(
        and_(
            HabitTracking.user_id == user_id,
            HabitTracking.habit_id == habit_id,
        )
    ).scalar() or 0

    if total_distance >= 100:
        achievement = db.query(Achievement).where(
            and_(
                Achievement.habit_id == habit_id,
                Achievement.check_function == 'running_100km_month_check'
            )
        ).first()

        if not achievement:
            habit = db.query(Habit).where(Habit.id == habit_id).first()
            achievement = Achievement(
                name="Стокилометровка (100 км в месяц)",
                description=f"Пробежал {total_distance:.1f} км за месяц",
                habit_id=habit_id,
                check_function='running_100km_month_check'
            )
            db.add(achievement)
            db.commit()
            db.refresh(achievement)

        return achievement.id
    return None
