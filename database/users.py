import json
import logging
from datetime import date, datetime, timedelta, UTC

import jwt
from fastapi import HTTPException
from fastapi.responses import JSONResponse
from sqlalchemy import select, and_
from sqlalchemy.orm import Session

from config import SECRET_KEY
from models import User, UserSettings
from request_models import ToggleSettingsUpdateRequest

logger = logging.getLogger("info_logger")
errors = logging.getLogger("error_logger")


def generate_token(user_id: int, user_name: str) -> str:
    token = jwt.encode({
        "username": f"{user_id} {user_name}",
        "exp": datetime.now(UTC) + timedelta(hours=1)
    }, SECRET_KEY, algorithm="HS256")
    return token


async def register(name: str, login: str, password: str, tg_nick: str, db: Session) -> JSONResponse:
    try:
        logger.info(f"Received registration request for user with login: {login}")
        new_user = register_user(name, login, password, tg_nick, db)
        logger.info(f"User '{login}' registered successfully.")
        return JSONResponse(
            content={"id": new_user.id, "answer": "success", "token": generate_token(new_user.id, name)})
    except HTTPException as e:
        errors.error(f"Error during registration for user '{login}': {e.detail}")
        raise e
    except Exception as e:
        errors.error(f"Unexpected error during registration for user '{login}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


def register_user(name: str, login: str, password: str, tg_name: str, db: Session) -> User:
    stmt = select(User).where(User.login == login)
    existing_user = db.execute(stmt).scalars().first()
    if existing_user:
        logger.warning(f"User with login '{login}' already exists.")
        raise HTTPException(
            status_code=400,
            detail={"id": -1, "error": "User with this login already exists"}
        )

    new_user = User(
        name=name,
        login=login,
        password=password,
        tg_name=tg_name,
        join_date=date.today()
    )
    db.add(new_user)
    db.flush()
    new_user_settings = UserSettings(user_id=new_user.id)
    db.add(new_user_settings)
    db.commit()

    logger.info(f"User '{login}' registered successfully with ID {new_user.id}.")
    return new_user


async def authenticate_user(login: str, password: str, db: Session) -> JSONResponse:
    try:
        logger.info(f"Authorization attempt for user with login: {login}")

        stmt = select(User).where(and_(User.login == login, User.password == password))
        existing_user = db.execute(stmt).scalars().first()

        if not existing_user:
            logger.error(f"Authentication failed for user '{login}'. Incorrect login or password.")
            return JSONResponse(
                content={"id": -1, "answer": "error"})

        logger.info(f"User '{login}' authenticated successfully.")
        return JSONResponse(
            content={"id": existing_user.id, "answer": "success",
                     "token": generate_token(existing_user.id, existing_user.name)})
    except Exception as e:
        logger.error(f"Unexpected error during authentication for user '{login}': {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")


async def update_user(user_id: int, name: str, login: str, password: str, tg_nick: str, db: Session) -> JSONResponse:
    try:
        logger.info(f"Updating user with ID: {user_id}")

        stmt = select(User).where(User.id == user_id)
        user = db.execute(stmt).scalars().first()

        if not user:
            logger.error(f"User with ID {user_id} not found.")
            raise HTTPException(status_code=404, detail="User not found")

        if name is not None:
            user.name = name
        if login is not None:
            existing_user_stmt = select(User).where(and_(User.login == login, User.id != user_id))
            existing_user = db.execute(existing_user_stmt).scalars().first()
            if existing_user:
                logger.error(f"Login '{login}' is already taken by another user.")
                raise HTTPException(
                    status_code=400,
                    detail="Login is already taken by another user"
                )
            user.login = login
        if password is not None:
            user.password = password
        if tg_nick is not None:
            user.tg_name = tg_nick

        db.commit()
        db.refresh(user)

        logger.info(f"User with ID {user_id} updated successfully.")
        return JSONResponse(content={"id": user.id, "answer": "success"})

    except HTTPException as e:
        logger.error(f"Error updating user with ID {user_id}: {e.detail}")
        raise e
    except Exception as e:
        logger.error(f"Unexpected error while updating user with ID {user_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")


async def load_toggles_settings(user_id: int, db: Session) -> JSONResponse:
    try:
        logger.info(f"Load toggles of user with ID: {user_id}")

        stmt = select(UserSettings).where(UserSettings.user_id == user_id)
        user = db.execute(stmt).scalars().first()

        if not user:
            answer = dict()
            answer['option1'] = False
            answer['option2'] = False
            answer['option3'] = False
            answer['option4'] = False
            return JSONResponse(content={"answer": "success", "toggles": answer})

        answer = dict()
        answer['option1'] = user.option1
        answer['option2'] = user.option2
        answer['option3'] = user.option3
        answer['option4'] = user.option4
        return JSONResponse(content={"answer": "success", "toggles": answer})

    except HTTPException as e:
        logger.error(f"Error updating user with ID {user_id}: {e.detail}")
        raise e
    except Exception as e:
        logger.error(f"Unexpected error while updating user with ID {user_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")


async def set_toggles_settings(user_id: int, toggles: ToggleSettingsUpdateRequest, db: Session) -> JSONResponse:
    try:
        logger.info(f"Set toggles of user with ID: {user_id}")

        stmt = select(UserSettings).where(UserSettings.user_id == user_id)
        user = db.execute(stmt).scalars().first()

        if not user:
            logger.error(f"User with ID {user_id} not found.")
            raise HTTPException(status_code=404, detail="User not found")

        user.option1 = toggles.option1
        user.option2 = toggles.option2
        user.option3 = toggles.option3
        user.option4 = toggles.option4

        db.commit()
        db.refresh(user)

        return JSONResponse(content={"answer": "success", "toggles": "success"})

    except HTTPException as e:
        logger.error(f"Error updating user with ID {user_id}: {e.detail}")
        raise e
    except Exception as e:
        logger.error(f"Unexpected error while updating user with ID {user_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")


async def load_settings(user_id: int, db: Session) -> JSONResponse:
    try:
        logger.info(f"Loading reminders for user ID: {user_id}")

        stmt = select(UserSettings).where(UserSettings.user_id == user_id)
        user = db.execute(stmt).scalars().first()
        if not user:
            logger.error(f"User with ID {user_id} not found.")
            raise HTTPException(status_code=404, detail="User not found")

        return JSONResponse(content={
            "answer": "success",
            "weekends": json.loads(user.weekends),
            "reminders": json.loads(user.reminders)
        }, media_type="application/json; charset=utf-8")


    except HTTPException as e:
        logger.error(f"Error loading reminders: {e.detail}")
        raise e
    except Exception as e:
        logger.error(f"Unexpected error loading reminders: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")


async def set_settings(user_id: int, reminders: list, weekends: list, db: Session) -> JSONResponse:
    try:
        logger.info(f"Updating reminders for user ID: {user_id}")

        stmt = select(UserSettings).where(UserSettings.user_id == user_id)
        user = db.execute(stmt).first()[0]

        if not user:
            errors.error(f"User with ID {user_id} not found.")
            raise HTTPException(status_code=404, detail="User not found")

        user.reminders = json.dumps(list(set(reminders)))
        user.weekends = json.dumps(list(set(weekends)))
        db.commit()
        db.refresh(user)

        return JSONResponse(content={
            "answer": "success",
            "reminders": "updated"
        })

    except HTTPException as e:
        errors.error(f"Error updating reminders: {e.detail}")
        raise e
    except Exception as e:
        errors.error(f"Unexpected error updating reminders: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")
