from sqlalchemy import Column, Integer, String, BigInteger, JSON
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

# Таблица пользователей
class User(Base):
    __tablename__ = 'users'

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    login = Column(String, nullable=False)
    password = Column(String, nullable=False)
    tg_id = Column(String(255), nullable=False)
    habits = Column(JSON, nullable=False)
    achievements = Column(JSON, nullable=False)
    groups = Column(JSON, nullable=False)
    competitions = Column(BigInteger, nullable=False)

# Таблица привычек
class Habit(Base):
    __tablename__ = 'habits'
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    description = Column(String(255), nullable=False)
    achievements = Column(JSON, nullable=False)

# Таблица достижений
class Achievement(Base):
    __tablename__ = 'achievements'

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    description = Column(String(255), nullable=False)
    condition = Column(JSON, nullable=False)

# Таблица групп
class Group(Base):
    __tablename__ = 'groups'

    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(String(255), nullable=False)
    participants = Column(JSON, nullable=False)
    habits = Column(JSON, nullable=False)
    competitions = Column(JSON, nullable=False)

# Таблица соревнований
class Competition(Base):
    __tablename__ = 'competitions'
    id = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(BigInteger, nullable=False)
    description = Column(String(255), nullable=False)
