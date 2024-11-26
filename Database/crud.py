from sqlalchemy.orm import Session
import models, schemas


def create_user(db: Session, user_name: str):
    db_user = models.User(name=user_name)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def create_habit(db: Session, habit: schemas.HabitCreate, user_id: int):
    db_habit = models.Habit(**habit.dict(), owner_id=user_id)
    db.add(db_habit)
    db.commit()
    db.refresh(db_habit)
    return db_habit


def get_user_habits(db: Session, user_id: int):
    return db.query(models.Habit).filter(models.Habit.owner_id == user_id).all()


def create_habit_entry(db: Session, entry: schemas.HabitEntryCreate, habit_id: int):
    db_entry = models.HabitEntry(**entry.dict(), habit_id=habit_id)
    db.add(db_entry)
    db.commit()
    db.refresh(db_entry)
    return db_entry
