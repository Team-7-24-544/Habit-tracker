from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# Настроим базу данных SQLite (или измените на вашу СУБД)
SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"

# Создаем движок базы данных
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})

# Создаем базовый класс для всех моделей SQLAlchemy
Base = declarative_base()

# Создаем сессию для взаимодействия с базой данных
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
