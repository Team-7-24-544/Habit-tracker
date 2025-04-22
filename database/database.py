from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base

# Создание подключения к SQLite
DATABASE_URL = "sqlite:///./data/example.sqlite"

engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


# Создание таблиц
def init_db():
    Base.metadata.create_all(bind=engine)


# Создание таблиц в базе данных
def update_database():
    global engine
    engine = create_engine(DATABASE_URL)
    Base.metadata.create_all(bind=engine)
