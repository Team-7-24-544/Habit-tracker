from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware

from achievements import get_last_10_achievements
from bot_message import redis
from config import check_token
from config import get_token
from database import SessionLocal, init_db
from emoji_calendar import get_emotions, set_emoji_for_day, get_habit_periods
from habits import add_habit, get_templates, get_template_by_id, get_habits, set_mark, get_all_habits
from logging_config import setup_logging
from models import Habit
from request_models import RegisterUserRequest, HabitCreateRequest, SetEmojiRequest, UserUpdateRequest, \
    SetMarkRequest, SettingsUpdateRequest, ProfileUpdateRequest
from user_profile import get_user_profile, update_user_profile
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


info_logger = logging.getLogger("info_logger")
error_logger = logging.getLogger("error_logger")


@app.on_event("startup")
def startup_event():
    init_db()


# Registration, login and e.t.c.------------------------------------------------------------
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


@app.post("/user/settings/set_toggles")
async def update_user_settings(data: ToggleSettingsUpdateRequest, token: str = Depends(get_token),
                               dp: Session = Depends(get_db)):
    check_token(token, data.user_id)
    return await set_toggles_settings(data.user_id, data, dp)


@app.get("/user/settings/load_toggles")
async def load_toggles_settings_(user_id: int, token: str = Depends(get_token), dp: Session = Depends(get_db)):
    check_token(token, user_id)
    return await load_toggles_settings(user_id, dp)


@app.post("/user/settings/set_settings")
async def set_settings_(data: SettingsUpdateRequest, token: str = Depends(get_token),
                        dp: Session = Depends(get_db)):
    check_token(token, data.user_id)
    return await set_settings(data.user_id, data.reminders, data.weekends, dp)


@app.get("/user/settings/load")
async def load_settings_(user_id: int, token: str = Depends(get_token), dp: Session = Depends(get_db)):
    check_token(token, user_id)
    return await load_settings(user_id, dp)


# ------------------------------------------------------------------------------------------


# Emotions----------------------------------------------------------------------------------
@app.get("/emotions/get_all_emoji")
async def get__emotions(user_id: int, token: str = Depends(get_token), db: Session = Depends(get_db)):
    check_token(token, user_id)
    return await get_emotions(user_id, db)


@app.post("/emotions/set_emoji")
async def set_emoji(data: SetEmojiRequest, token: str = Depends(get_token), db: Session = Depends(get_db)):
    check_token(token, data.user_id)
    return await set_emoji_for_day(data.user_id, data.emoji, db)


# ------------------------------------------------------------------------------------------


# Achivements-------------------------------------------------------------------------------
@app.get("/achievements/get_last")
async def get_last_achievements(user_id: int, token: str = Depends(get_token), db: Session = Depends(get_db)):
    check_token(token, user_id)
    return await get_last_10_achievements(user_id, db)


# ------------------------------------------------------------------------------------------


# Habits------------------------------------------------------------------------------------
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


@app.post("/habits/update_schedule")
async def update_habit_schedule(user_id: int, habit_id: str, time_table: str, token: str = Depends(get_token),
                                db: Session = Depends(get_db)):
    check_token(token, user_id)
    try:
        habit = db.query(Habit).filter(Habit.id == habit_id).first()
        if not habit:
            raise HTTPException(status_code=404, detail="Habit not found")

        schedule = json.loads(time_table)

        for day in ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']:
            if day in schedule:
                setattr(habit, day, json.dumps(schedule[day]))
            else:
                setattr(habit, day, '{}')

        db.commit()
        return JSONResponse(content={"answer": "success"})

    except Exception as e:
        logger.error(f"Error updating habit schedule: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


# ------------------------------------------------------------------------------------------


# Profile------------------------------------------------------------------------------
@app.get("/user/profile")
async def get_profile(user_id: int, token: str = Depends(get_token), db: Session = Depends(get_db)):
    """
    Получение данных профиля для пользователя с указанным user_id.
    """
    check_token(token, user_id)
    return await get_user_profile(user_id, db)


@app.post("/user/profile/update")
async def update_profile(data: ProfileUpdateRequest, token: str = Depends(get_token), db: Session = Depends(get_db),
                         ):
    """
    Обновление данных профиля для пользователя с указанным user_id.
    Если какие-то поля не переданы, они не изменяются.
    """
    check_token(token, data.user_id)

    return await update_user_profile(
        data.user_id,
        data.avatar_url,
        data.nickname,
        data.about,
        data.goal,
        data.telegram,
        data.monthly_habits,
        data.monthly_quote,
        db
    )


# ------------------------------------------------------------------------------------------

if __name__ == "__main__":
    import uvicorn

    print(redis)
    uvicorn.run(app, host="127.0.0.1", port=5000, ssl_keyfile='data/key.pem', ssl_certfile='data/cert.pem')
