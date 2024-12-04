from typing import Optional, Dict, Any

from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session

from database import SessionLocal
from models import Competition, User, Habit, Achievement, Group

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Получение сессии базы данных
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Роуты для пользователей
@app.post("/users/")
def create_user(name: int, tg_id: str, habits: dict, achievements: dict, groups: dict, competitions: int,
                db: Session = Depends(get_db)):
    user = User(name=name, tg_id=tg_id, habits=habits, achievements=achievements, groups=groups,
                competitions=competitions)
    db.add(user)
    db.commit()
    db.refresh(user)
    return user


@app.get("/users/")
def get_users(db: Session = Depends(get_db)):
    return db.query(User).all()


# Роуты для привычек
@app.post("/habits/")
def create_habit(name: str, description: str, achievements: dict, db: Session = Depends(get_db)):
    habit = Habit(name=name, description=description, achievements=achievements)
    db.add(habit)
    db.commit()
    db.refresh(habit)
    return habit


@app.get("/habits/")
def get_habits(db: Session = Depends(get_db)):
    return db.query(Habit).all()


# Роуты для достижений
@app.post("/achievements/")
def create_achievement(name: str, description: str, condition: dict, db: Session = Depends(get_db)):
    achievement = Achievement(name=name, description=description, condition=condition)
    db.add(achievement)
    db.commit()
    db.refresh(achievement)
    return achievement


@app.get("/achievements/")
def get_achievements(db: Session = Depends(get_db)):
    return db.query(Achievement).all()


# Роуты для групп
@app.post("/groups/")
def create_group(name: str, participants: dict, habits: dict, competitions: dict, db: Session = Depends(get_db)):
    group = Group(name=name, participants=participants, habits=habits, competitions=competitions)
    db.add(group)
    db.commit()
    db.refresh(group)
    return group


@app.get("/groups/")
def get_groups(db: Session = Depends(get_db)):
    return db.query(Group).all()


# Роуты для соревнований
@app.post("/competitions/")
def create_competition(name: int, description: str, db: Session = Depends(get_db)):
    competition = Competition(name=name, description=description)
    db.add(competition)
    db.commit()
    db.refresh(competition)
    return competition


@app.get("/competitions/")
def get_competitions(db: Session = Depends(get_db)):
    return db.query(Competition).all()


@app.get("/check_api")
async def get_query(id: int, type: str, params: Optional[Dict[str, Any]] = None):
    print(f"Received id: {id}, type: {type}, params: {params}")
    if type == "status" and id == 544:
        return JSONResponse(content={"id": id, "body": {"message": "Hello, Б24-544!"}})
    return JSONResponse(content={"id": id, "body": {"message": "Hello!"}})
