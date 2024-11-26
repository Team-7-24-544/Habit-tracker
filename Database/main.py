from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
import models, schemas, crud
from database import SessionLocal, engine

models.Base.metadata.create_all(bind=engine)

app = FastAPI()


# Dependency для получения сессии БД
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.post("/users/{user_id}/habits/", response_model=schemas.Habit)
def create_habit_for_user(user_id: int, habit: schemas.HabitCreate, db: Session = Depends(get_db)):
    return crud.create_habit(db=db, habit=habit, user_id=user_id)


@app.get("/users/{user_id}/habits/", response_model=list[schemas.Habit])
def read_user_habits(user_id: int, db: Session = Depends(get_db)):
    return crud.get_user_habits(db=db, user_id=user_id)


@app.post("/habits/{habit_id}/entries/", response_model=schemas.HabitEntry)
def create_habit_entry(habit_id: int, entry: schemas.HabitEntryCreate, db: Session = Depends(get_db)):
    return crud.create_habit_entry(db=db, entry=entry, habit_id=habit_id)
