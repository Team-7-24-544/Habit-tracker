from sqlalchemy import Column, Integer, String, Date, Boolean, ForeignKey
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    habits = relationship("Habit", back_populates="owner")


class Habit(Base):
    __tablename__ = "habits"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    start_date = Column(Date)
    owner_id = Column(Integer, ForeignKey("users.id"))
    owner = relationship("User", back_populates="habits")
    entries = relationship("HabitEntry", back_populates="habit")


class HabitEntry(Base):
    __tablename__ = "habit_entries"
    id = Column(Integer, primary_key=True, index=True)
    date = Column(Date, index=True)
    completed = Column(Boolean, default=False)
    habit_id = Column(Integer, ForeignKey("habits.id"))
    habit = relationship("Habit", back_populates="entries")
