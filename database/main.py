from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware

from database import SessionLocal, init_db
from achievements import get_last_10_achievements
from emoji_calendar import get_emotions, set_emoji_for_day, get_habit_periods
from habits import add_habit, get_templates, get_template_by_id, get_habits, set_mark
from logging_config import setup_logging
from users import *

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


@app.post("/habits/create")
async def habits_create(user_id: int, name: str, description: str, time_table: str, db: Session = Depends(get_db)):
    return await add_habit(user_id, name, description, time_table, db)


@app.get("/emotions/get_all")
async def get__emotions(user_id: int, db: Session = Depends(get_db)):
    return await get_emotions(user_id, db)


@app.post("/emotions/set")
async def set_emoji(user_id: int, emoji: int, db: Session = Depends(get_db)):
    return await set_emoji_for_day(user_id, emoji, db)


@app.get("/achievements/get_last")
async def get_last_achievements(user_id: int, db: Session = Depends(get_db)):
    return await get_last_10_achievements(user_id, db)


@app.get("/habits/get_templates")
async def get_templates_(db: Session = Depends(get_db)):
    return await get_templates(db)


@app.get("/habits/get_selected_template")
async def get_templates_(habit_id: int, db: Session = Depends(get_db)):
    return await get_template_by_id(habit_id, db)


@app.post("/user/update")
async def update_user_endpoint(user_id: int, name: str = None, login: str = None,
                               password: str = None, tg_nick: str = None,
                               db: Session = Depends(get_db)):
    return await update_user(user_id, name, login, password, tg_nick, db)


@app.get("/habits/get_periods")
async def get_periods(user_id: int, db: Session = Depends(get_db)):
    return await get_habit_periods(user_id, db)


@app.get("/habits/get_today_habits")
async def get_today_habits(user_id: int, db: Session = Depends(get_db)):
    return await get_habits(user_id, db)


@app.post("/habits/set_mark")
async def set_mark_(user_id: int, habit_id: int, db: Session = Depends(get_db)):
    return await set_mark(user_id, habit_id, db)
