from typing import Optional, Dict, Any

from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel
from sqlalchemy import select, and_, or_
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from database import SessionLocal, init_db
from models import User
from models import Habit

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


@app.on_event("startup")
def startup_event():
    init_db()


@app.get("/check_api")
async def get_query(id: int, params: Optional[Dict[str, Any]] = None):
    print(f"Received id: {id}, params: {params}")
    return JSONResponse(content={"id": id, "body": {"message": f"Hello, Б24-{id}!"}})


@app.post("/register")
async def register(name: str, login: str, password: str, tg_nick: str, db: Session = Depends(get_db)):
    try:
        stmt = select(User).where(User.login == login)
        existing_user = db.execute(stmt).scalars().first()
        if existing_user:
            raise HTTPException(
                status_code=400,
                detail={"id": -1, "answer": "User with this login already exists"}
            )

        new_user = User(
            name=name,
            login=login,
            password=password,
            tg_name=tg_nick
        )
        db.add(new_user)
        db.commit()
        db.refresh(new_user)

        return JSONResponse(content={"id": new_user.id, "answer": "success"})
    except IntegrityError as e:
        db.rollback()
        print(e)
        raise HTTPException(
            status_code=400,
            detail={"id": -1, "answer": "User with this login already exists"}
        )
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/login")
async def login(password: str, login: str, db: Session = Depends(get_db)):
    try:
        print(f"Authorization: {login} {password}")

        stmt = select(User).where(and_(User.login == login, User.password == password))
        existing_user = db.execute(stmt).scalars().first()

        if not existing_user:
            raise HTTPException(status_code=400,
                                detail={"id": -1, "answer": "User does not exist or password is incorrect"})

        return JSONResponse(content={"id": existing_user.id, "answer": "success"})
    finally:
        db.close()
        return JSONResponse(content={"id": 0, "answer": "ERROR  "})


@app.post("/habits/create")
async def habits_create(name: str, description: str, time: str, week_days: str, duration: int,
                        db: Session = Depends(get_db)):
    try:
        new_habbit = Habit(
            name=name,
            description=description,
            time=time,
            week_days=week_days,
            duration=duration
        )
        print(f"Created new habit: {name} {description} {time} {week_days} {duration}")
        db.add(new_habbit)
        db.commit()
        db.refresh(new_habbit)

        return JSONResponse(content={"answer": "success"})
    except IntegrityError as e:
        db.rollback()
        print(e)
        raise HTTPException(
            status_code=400,
            detail={"id": -1, "answer": "Habit already exists"}
        )
    except Exception as e:
        print(e)
        db.rollback()
        raise HTTPException(status_code=500, detail=str(e))
