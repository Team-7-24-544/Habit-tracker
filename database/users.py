import logging

from sqlalchemy import select, and_
from sqlalchemy.orm import Session
from datetime import date
from fastapi import HTTPException
from fastapi.responses import JSONResponse

from models import User, MoodTracking

logger = logging.getLogger(__name__)


async def register(name: str, login: str, password: str, tg_nick: str, db: Session):
    try:
        logger.info(f"Received registration request for user with login: {login}")
        new_user = register_user(name, login, password, tg_nick, db)
        logger.info(f"User '{login}' registered successfully.")
        return JSONResponse(content={"id": new_user.id, "answer": "success"})
    except HTTPException as e:
        logger.error(f"Error during registration for user '{login}': {e.detail}")
        raise e
    except Exception as e:
        logger.error(f"Unexpected error during registration for user '{login}': {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))


def register_user(name: str, login: str, password: str, tg_name: str, db: Session):
    stmt = select(User).where(User.login == login)
    existing_user = db.execute(stmt).scalars().first()
    if existing_user:
        logger.warning(f"User with login '{login}' already exists.")
        raise HTTPException(
            status_code=400,
            detail={"id": -1, "answer": "User with this login already exists"}
        )

    new_user = User(
        name=name,
        login=login,
        password=password,
        tg_name=tg_name,
        join_date=date.today()
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    logger.info(f"User '{login}' registered successfully with ID {new_user.id}.")
    return new_user


async def authenticate_user(login: str, password: str, db: Session):
    try:
        logger.info(f"Authorization attempt for user: {login}")

        stmt = select(User).where(and_(User.login == login, User.password == password))
        existing_user = db.execute(stmt).scalars().first()

        if not existing_user:
            logger.error(f"Authentication failed for user '{login}'. Incorrect login or password.")
            raise HTTPException(status_code=400,
                                detail={"id": -1, "answer": "User does not exist or password is incorrect"})

        logger.info(f"User '{login}' authenticated successfully.")
        return JSONResponse(content={"id": existing_user.id, "answer": "success"})
    except Exception as e:
        logger.error(f"Unexpected error during authentication for user '{login}': {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")
