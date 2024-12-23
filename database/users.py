import logging

from sqlalchemy import select, and_
from sqlalchemy.orm import Session
from datetime import date
from fastapi import HTTPException
from fastapi.responses import JSONResponse

from models import User

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


async def update_user(user_id: int, name: str, login: str, password: str, tg_nick: str, db: Session):
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
