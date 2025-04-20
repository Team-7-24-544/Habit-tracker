from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware

from database import SessionLocal, init_db
from achievements import get_last_10_achievements
from config import check_token, get_token
from request_models import RegisterUserRequest, HabitCreateRequest, SetEmojiRequest, UserUpdateRequest, \
    SetMarkRequest
from emoji_calendar import get_emotions, set_emoji_for_day, get_habit_periods
from habits import add_habit, get_templates, get_template_by_id, get_habits, set_mark, get_all_habits
from logging_config import setup_logging
from users import *
from user_profile import get_user_profile, update_user_profile

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


@app.post("/user/register")
async def register_user_endpoint(data: RegisterUserRequest, db: Session = Depends(get_db)):
    return await register(data.name, data.login, data.password, data.tg_nick, db)


@app.get("/user/login")
async def login_endpoint(password: str, login: str, db: Session = Depends(get_db)):
    return await authenticate_user(login, password, db)


@app.post("/user/update")
async def update_user_endpoint(data: UserUpdateRequest, token: str = Depends(get_token),
                               db: Session = Depends(get_db)):
    check_token(token, data.user_id)
    return await update_user(data.user_id, data.name, data.login, data.password, data.tg_nick, db)


@app.get("/emotions/get_all_emoji")
async def get__emotions(user_id: int, token: str = Depends(get_token), db: Session = Depends(get_db)):
    check_token(token, user_id)
    return await get_emotions(user_id, db)


@app.post("/emotions/set_emoji")
async def set_emoji(data: SetEmojiRequest, token: str = Depends(get_token), db: Session = Depends(get_db)):
    check_token(token, data.user_id)
    return await set_emoji_for_day(data.user_id, data.emoji, db)


@app.get("/achievements/get_last")
async def get_last_achievements(user_id: int, token: str = Depends(get_token), db: Session = Depends(get_db)):
    check_token(token, user_id)
    return await get_last_10_achievements(user_id, db)


@app.post("/habits/create")
async def habits_create(data: HabitCreateRequest, token: str = Depends(get_token),
                        db: Session = Depends(get_db)):
    check_token(token, data.user_id)
    return await add_habit(data.user_id, data.name, data.description, data.time_table, db)


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

@app.get("/user/profile")
async def get_profile(user_id: int, db: Session = Depends(get_db)):
    """
    Получение данных профиля для пользователя с указанным user_id.
    """
    return await get_user_profile(user_id, db)


#новые------------------------------------------------------------
@app.post("/user/profile/update")
async def update_profile(
    user_id: int,
    avatar_url: str = None,
    nickname: str = None,
    about: str = None,
    goal: str = None,
    telegram: str = None,
    monthly_habits: str = None,
    monthly_quote: str = None,
    db: Session = Depends(get_db)
):
    """
    Обновление данных профиля для пользователя с указанным user_id.
    Если какие-то поля не переданы, они не изменяются.
    """
    return await update_user_profile(
        user_id,
        avatar_url,
        nickname,
        about,
        goal,
        telegram,
        monthly_habits,
        monthly_quote,
        db
    )
#------------------------------------------------------------
@app.get("/habits/get_periods")
async def get_periods(user_id: int, token: str = Depends(get_token), db: Session = Depends(get_db)):
    check_token(token, user_id)
    return await get_habit_periods(user_id, db)


@app.get("/habits/get_today_habits")
async def get_today_habits(user_id: int, token: str = Depends(get_token), db: Session = Depends(get_db)):
    check_token(token, user_id)
    return await get_habits(user_id, db)


@app.post("/habits/set_mark")
async def set_mark_(data: SetMarkRequest, token: str = Depends(get_token), db: Session = Depends(get_db)):
    check_token(token, data.user_id)
    return await set_mark(data.user_id, data.habit_id, db)


@app.get("/habits/get_all_habits")
async def get_all_habits_(user_id: int, token: str = Depends(get_token), db: Session = Depends(get_db)):
    check_token(token, user_id)
    return await get_all_habits(user_id, db)

@app.get("/user/profile")
async def get_profile(user_id: int, db: Session = Depends(get_db)):
    """
    Получение данных профиля для пользователя с указанным user_id.
    """
    return await get_user_profile(user_id, db)


#новые------------------------------------------------------------
@app.post("/user/profile/update")
async def update_profile(
    user_id: int,
    avatar_url: str = None,
    nickname: str = None,
    about: str = None,
    goal: str = None,
    telegram: str = None,
    monthly_habits: str = None,
    monthly_quote: str = None,
    db: Session = Depends(get_db)
):
    """
    Обновление данных профиля для пользователя с указанным user_id.
    Если какие-то поля не переданы, они не изменяются.
    """
    return await update_user_profile(
        user_id,
        avatar_url,
        nickname,
        about,
        goal,
        telegram,
        monthly_habits,
        monthly_quote,
        db
    )
#------------------------------------------------------------