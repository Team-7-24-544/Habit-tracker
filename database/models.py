from sqlalchemy import Column, String, BigInteger, Boolean, Integer
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


# Таблица пользователей
class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    login = Column(String, nullable=False, unique=True)
    password = Column(String, nullable=False)
    tg_name = Column(String, nullable=False)
    tg_checked = Column(Boolean, nullable=False, default=False)


class Habit(Base):
    __tablename__ = 'habit'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    description = Column(String, nullable=False)
    time = Column(String, nullable=False)
    week_days = Column(String, nullable=False)
    duration = Column(BigInteger, nullable=False)
