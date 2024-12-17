import logging

from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session

from database import SessionLocal, init_db
from achievements import get_last_10_achievements
from emoji_calendar import get_emotions, set_emoji_for_day
from habits import add_habit
from logging_config import setup_logging
from users import register, authenticate_user

setup_logging()
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


logger = logging.getLogger(__name__)


@app.on_event("startup")
def startup_event():
    init_db()


@app.post("/register")
async def register_user_endpoint(name: str, login: str, password: str, tg_nick: str, db: Session = Depends(get_db)):
    return await register(name, login, password, tg_nick, db)


@app.get("/login")
async def login_endpoint(password: str, login: str, db: Session = Depends(get_db)):
    return await authenticate_user(login, password, db)


@app.get("/habits/create")
async def habits_create(user_id: int, name: str, description: str, time_table: str, db: Session = Depends(get_db)):
    return await add_habit(user_id, name, description, time_table, db)


@app.get("/emotions")
async def get__emotions(user_id: int, db: Session = Depends(get_db)):
    return await get_emotions(user_id, db)


@app.post("/set_emoji")
async def set_emoji(user_id: int, emoji: int, db: Session = Depends(get_db)):
    return await set_emoji_for_day(user_id, emoji, db)


@app.get("/last_achievements")
async def get_last_achievements(user_id: int, db: Session = Depends(get_db)):
    return await get_last_10_achievements(user_id, db)
