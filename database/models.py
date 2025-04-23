import json

from sqlalchemy import Column, String, Boolean, Integer, Date, Text
from sqlalchemy import ForeignKey
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    login = Column(String, unique=True, nullable=False)
    password = Column(String, nullable=False)
    tg_name = Column(String, nullable=False)
    tg_checked = Column(Boolean, default=False, nullable=False)
    chat_id = Column(Integer, default=-1, nullable=False)
    join_date = Column(Date, nullable=False)

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

    def __repr__(self):
        return f"<Habit(name={self.name}, description={self.description})>"


class MoodTracking(Base):
    __tablename__ = 'mood_tracking'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, nullable=False)
    mood_date = Column(String, nullable=False)
    mood_value = Column(Integer, nullable=False)

    def __repr__(self):
        return f"<MoodTracking(user_id={self.user_id}, mood_date={self.mood_date}, mood_value={self.mood_value})>"


class HabitTracking(Base):
    __tablename__ = 'habit_tracking'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, nullable=False)
    habit_id = Column(Integer, nullable=False)
    start = Column(String, nullable=False)
    end = Column(String, nullable=True, default=None)
    missed_count = Column(Integer, default=0, nullable=False)
    monthly_schedule = Column(String, nullable=False)

    def __repr__(self):
        return f"<HabitTracking(user_id={self.user_id}, habit_id={self.habit_id}, start={self.start}, end={self.end})>"


class Achievement(Base):
    __tablename__ = 'all_achievements'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    description = Column(String, nullable=False)
    condition = Column(String, nullable=False)

    def __repr__(self):
        return f"<Achievement(name={self.name}, description={self.description})>"


class UserAchievement(Base):
    __tablename__ = 'user_achievements'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, nullable=False)
    achievement_id = Column(Integer, nullable=False)
    date_achieved = Column(Date, nullable=False)

    def __repr__(self):
        return f"<UserAchievement(user_id={self.user_id}, achievement_id={self.achievement_id}, date_achieved={self.date_achieved})>"


class Group(Base):
    __tablename__ = 'groups'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    created_at = Column(Date, nullable=False)
    creator_id = Column(Integer, nullable=False)

    def __repr__(self):
        return f"<Group(name={self.name}, created_at={self.created_at}, creator_id={self.creator_id})>"


class GroupMembership(Base):
    __tablename__ = 'group_memberships'

    id = Column(Integer, primary_key=True, autoincrement=True)
    group_id = Column(Integer, nullable=False)
    user_id = Column(Integer, nullable=False)
    joined_at = Column(Date, nullable=False)

    def __repr__(self):
        return f"<GroupMembership(group_id={self.group_id}, user_id={self.user_id}, joined_at={self.joined_at})>"


class HabitTemplate(Base):
    __tablename__ = 'habit_templates'

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

    def __repr__(self):
        return f"<Habit(name={self.name}, description={self.description})>"


class UserProfile(Base):
    __tablename__ = 'user_profiles'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False, unique=True)
    avatar_url = Column(String, nullable=False, default='https://via.placeholder.com/200')
    nickname = Column(String, nullable=False)
    about = Column(String, nullable=True)
    goal = Column(String, nullable=True)
    telegram = Column(String, nullable=True)
    monthly_habits = Column(String, nullable=True)
    monthly_quote = Column(String, nullable=True)

    def __repr__(self):
        return (f"<UserProfile(user_id={self.user_id}, nickname={self.nickname}, "
                f"about={self.about}, goal={self.goal})>")


class UserSettings(Base):
    __tablename__ = 'user_settings'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    option1 = Column(Boolean, nullable=False, default=False)
    option2 = Column(Boolean, nullable=False, default=False)
    option3 = Column(Boolean, nullable=False, default=False)
    option4 = Column(Boolean, nullable=False, default=False)
    reminders = Column(Text, default=json.dumps([]))
    weekends = Column(Text, default=json.dumps([]))

    def __repr__(self):
        return (f"<UserSettings(user_id={self.user_id}, option1={self.option1}, option2={self.option2}, "
                f"option3={self.option3},option4={self.option4})>")
