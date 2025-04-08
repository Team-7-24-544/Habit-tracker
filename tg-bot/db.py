from sqlalchemy import create_engine, Column, Integer, String, Boolean, Date, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from config import DATABASE_URL

Base = declarative_base()
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    login = Column(String, unique=True, nullable=False)
    password = Column(String, nullable=False)
    tg_name = Column(String, nullable=False)
    tg_checked = Column(Boolean, default=False, nullable=False)
    join_date = Column(Date, nullable=False)
    chat_id = Column(Integer, default=-1, nullable=False)

    habits_tracking = relationship("HabitTracking", back_populates="user")

    def __repr__(self):
        return f"<User(id={self.id}, name={self.name}, login={self.login}, tg_name={self.tg_name}, join_date={self.join_date})>"


class Habit(Base):
    __tablename__ = 'habit'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    description = Column(String, nullable=False)
    monday = Column(String, nullable=False)
    tuesday = Column(String, nullable=False)
    wednesday = Column(String, nullable=False)
    thursday = Column(String, nullable=False)
    friday = Column(String, nullable=False)
    saturday = Column(String, nullable=False)
    sunday = Column(String, nullable=False)
    habit_tracking = relationship("HabitTracking", back_populates="habit")

    def __repr__(self):
        return f"<Habit(name={self.name}, description={self.description})>"


class HabitTracking(Base):
    __tablename__ = 'habit_tracking'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    habit_id = Column(Integer, ForeignKey('habit.id'), nullable=False)
    start = Column(String, nullable=False)
    end = Column(String, nullable=True, default=None)
    missed_count = Column(Integer, default=0, nullable=False)
    monthly_schedule = Column(String, nullable=False)
    user = relationship("User", back_populates="habits_tracking")
    habit = relationship("Habit", back_populates="habit_tracking")

    def __repr__(self):
        return f"<HabitTracking(user_id={self.user_id}, habit_id={self.habit_id}, start={self.start}, end={self.end})>"


Base.metadata.create_all(bind=engine)
