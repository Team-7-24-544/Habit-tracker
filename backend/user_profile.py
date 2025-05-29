import logging
import shutil
from pathlib import Path

from fastapi import HTTPException, UploadFile, File
from fastapi.responses import JSONResponse
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session
from starlette.responses import FileResponse

from models import UserProfile, User

logger = logging.getLogger("info_logger")
errors = logging.getLogger("error_logger")


async def get_user_profile(user_id: int, db: Session):
    """
    Получает данные профиля для указанного пользователя.
    """
    logger.info(f"Fetching profile for user {user_id}")
    try:
        # Получаем профиль по внешнему ключу user_id
        profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
        if not profile:
            user = db.query(User).filter(User.id == user_id).first()
            if not user:
                errors.error(f"User {user_id} not found")
                raise HTTPException(status_code=404, detail="User not found")
            profile = UserProfile(user_id=user_id, nickname=user.name, telegram=user.tg_name, avatar_url="none")
            db.add(profile)
            db.commit()

        response = {
            "answer": "success",
            "profile": {
                "avatar_url": profile.avatar_url,
                "nickname": profile.nickname,
                "about": profile.about,
                "goal": profile.goal,
                "telegram": profile.telegram,
                "monthly_habits": profile.monthly_habits,
                "monthly_quote": profile.monthly_quote
            }
        }
        return JSONResponse(content=response, media_type="application/json; charset=utf-8")

    except IntegrityError as e:
        errors.error(f"Error fetching profile for user {user_id}: {e}")
        raise HTTPException(status_code=400, detail="Error fetching profile")
    except Exception as e:
        db.rollback()
        errors.error(f"Unexpected error fetching profile for user {user_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


async def update_user_profile(
        user_id: int,
        avatar_url: str = None,
        nickname: str = None,
        about: str = None,
        goal: str = None,
        telegram: str = None,
        monthly_habits: str = None,
        monthly_quote: str = None,
        db: Session = None
):
    """
    Обновляет данные профиля для указанного пользователя.
    Все параметры необязательные, если параметр не передан, соответствующее поле не обновляется.
    """
    logger.info(f"Updating profile for user {user_id}")
    try:
        profile = db.query(UserProfile).filter(UserProfile.user_id == user_id).first()
        if not profile:
            errors.error(f"Profile not found")
            raise HTTPException(status_code=404, detail="Profile not found")

        # Обновляем поля, если они переданы в запросе
        if avatar_url is not None:
            profile.avatar_url = avatar_url
        if nickname is not None:
            profile.nickname = nickname
        if about is not None:
            profile.about = about
        if goal is not None:
            profile.goal = goal
        if telegram is not None:
            profile.telegram = telegram
        if monthly_habits is not None:
            profile.monthly_habits = monthly_habits
        if monthly_quote is not None:
            profile.monthly_quote = monthly_quote

        db.commit()
        return JSONResponse(content={"answer": "success"}, media_type="application/json; charset=utf-8")

    except IntegrityError as e:
        errors.error(f"Error updating profile for user {user_id}: {e}")
        db.rollback()
        raise HTTPException(status_code=400, detail="Error updating profile")
    except Exception as e:
        db.rollback()
        errors.error(f"Unexpected error updating profile for user {user_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


async def upload_image(user_id: int, file: UploadFile = File(...)):
    DATA_DIR = Path(__file__).resolve().parent.parent / "database" / "photo"
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    file_path = DATA_DIR / f"user_{user_id}.jpg"

    with file_path.open("wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    return {"message": f"Изображение сохранено как {file_path.name}"}


async def get_image(user_id: int):
    DATA_DIR = Path(__file__).resolve().parent.parent / "database" / "photo"
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    file_path = DATA_DIR / f"user_{user_id}.jpg"

    if not file_path.exists():
        file_path = DATA_DIR / "none.jpeg"

    return FileResponse(path=file_path, media_type="image/jpeg", filename=file_path.name)
