from sqlalchemy import Column, String, BigInteger, Boolean, Integer, Date
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
    join_date = Column(Date, nullable=False)

    def __repr__(self):
        return f"<User(id={self.id}, name={self.name}, login={self.login}, tg_name={self.tg_name}, join_date={self.join_date})>"


class Habit(Base):
    __tablename__ = 'habit'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    description = Column(String, nullable=False)
    time = Column(String, nullable=False)
    week_days = Column(String, nullable=False)
    duration = Column(BigInteger, nullable=False)
    notifications = Column(String, nullable=False)

    def __repr__(self):
        return f"<Habit(name={self.name}, description={self.description}, time={self.time})>"


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
    date = Column(Date, nullable=False)
    is_done = Column(Boolean, default=False, nullable=False)
    missed_count = Column(Integer, default=0, nullable=False)
    monthly_schedule = Column(String, nullable=False)

    def __repr__(self):
        return f"<HabitTracking(user_id={self.user_id}, habit_id={self.habit_id}, date={self.date})>"


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
    time = Column(String, nullable=False)
    week_days = Column(String, nullable=False)
    duration = Column(BigInteger, nullable=False)

    def __repr__(self):
        return f"<HabitTemplate(name={self.name}, description={self.description}, time={self.time})>"
