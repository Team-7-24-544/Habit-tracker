"""
Файл с реализацией проверок получения новых достижений пользователем
"""

import logging
from datetime import datetime

from sqlalchemy import and_
from sqlalchemy.orm import Session

from models import HabitTracking, Achievement, Habit, User

logger = logging.getLogger("info_logger")
errors = logging.getLogger("error_logger")


def streak_check(user_id: int, habit_id: int, db: Session):
    def next_stage(current_streak):
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
        streak = next_stage(streak)
    if streak == habit_tracking.streak:
        habit = db.query(Habit).where(Habit.id == habit_id).first()
        name = 'Ни дня без "' + habit.name + '"'
        description = f"выполнений подряд: {streak}"
        achievement = db.query(Achievement).where(
            and_(Achievement.habit_id == habit_id, Achievement.check_function == 'streak_check',
                 Achievement.name == name, Achievement.description == description)).first()

        if achievement is None:
            achievement = Achievement(name=name, description=description, habit_id=habit_id,
                                      check_function='streak_check')
            db.add(achievement)
            db.commit()
            db.refresh(achievement)

        return achievement.id


def total_check(user_id: int, habit_id: int, db: Session):
    """общее кол-во выполнений"""

    def next_stage(current):
        if current < 10:
            return current + 5
        if current < 20:
            return current + 10
        if current < 100:
            return current + 20
        return current + 50

    value = 1
    habit_tracking = db.query(HabitTracking).where(
        and_(HabitTracking.user_id == user_id, HabitTracking.habit_id == habit_id)).first()
    if habit_tracking is None:
        return
    while value < habit_tracking.value:
        value = next_stage(value)
    if value == habit_tracking.value:
        habit = db.query(Habit).where(Habit.id == habit_id).first()
        name = 'Уверенный путь к "' + habit.name + '"'
        description = f"Всего выполнений: {value}"
        achievement = db.query(Achievement).where(
            and_(Achievement.habit_id == habit_id, Achievement.check_function == 'total_check',
                 Achievement.name == name, Achievement.description == description)).first()

        if achievement is None:
            achievement = Achievement(name=name, description=description, habit_id=habit_id,
                                      check_function='total_check')
            db.add(achievement)
            db.commit()
            db.refresh(achievement)

        return achievement.id


def some_custom_check(user_id, habit_id, db):
    """Проверка получения достижения связанного с habit_id"""
    pass


def unique_habits(user_id: int, habit_id: int, db: Session):
    """общее кол-во уникальных привычек выполнений"""
    tracking_all = db.query(HabitTracking).where(HabitTracking.user_id == user_id).all()
    cnt = 0
    for tracking in tracking_all:
        habit = db.query(Habit).where(Habit.id == tracking.habit_id).first()
        habits = db.query(Habit).where(Habit.name == habit.name).all()
        if len(habits):
            cnt += 1

    def next_stage(stage):
        if stage < 5:
            return stage + 1
        return stage + 5

    current = 0
    while cnt < next_stage(current):
        current = next_stage(current)
    if current != cnt or cnt == 0:
        return
    name = "Вперед за неизведанным!"
    description = f"Начато уникальных привычек: {cnt}"
    achievement = db.query(Achievement).where(and_(Achievement.habit_id == -1,
                                                   Achievement.name == name,
                                                   Achievement.description == description,
                                                   Achievement.check_function == 'unique_habits')).all()
    if achievement is None:
        achievement = Achievement(name=name, description=description, habit_id=-1,
                                  check_function='unique_habits')
        db.add(achievement)
        db.commit()
        db.refresh(achievement)

    return achievement.id


def together(user_id: int, habit_id: int, db: Session):
    user = db.query(User).where(User.id == user_id).first()
    dif = (datetime.today() - datetime.strptime(user.join_date, '%Y-%m-%d')).days

    def next_stage(stage):
        if stage < 90:
            return stage + 30
        return stage + 100

    current = 0
    while dif < next_stage(current):
        current = next_stage(current)
    if current != dif or dif == 0:
        return
    name = "Верные друзья!"
    description = f"Пользуетесь трекером дней: {dif}"
    achievement = db.query(Achievement).where(and_(Achievement.habit_id == -2,
                                                   Achievement.name == name,
                                                   Achievement.description == description,
                                                   Achievement.check_function == 'together')).all()
    if achievement is None:
        achievement = Achievement(name=name, description=description, habit_id=-2,
                                  check_function='together')
        db.add(achievement)
        db.commit()
        db.refresh(achievement)

    return achievement.id
