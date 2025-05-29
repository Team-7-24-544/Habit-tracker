"""
Модели для обработки POST-запросов
"""

from pydantic import BaseModel


class RegisterUserRequest(BaseModel):
    name: str
    login: str
    password: str
    tg_nick: str


class HabitCreateRequest(BaseModel):
    user_id: int
    name: str
    description: str
    time_table: str


class SetEmojiRequest(BaseModel):
    user_id: int
    emoji: int


class UserUpdateRequest(BaseModel):
    user_id: int
    name: str = None
    login: str = None
    password: str = None
    tg_nick: str = None


class SetMarkRequest(BaseModel):
    user_id: int
    habit_id: int


class ToggleSettingsUpdateRequest(BaseModel):
    user_id: int
    option1: bool
    option2: bool
    option3: bool
    option4: bool


class SettingsUpdateRequest(BaseModel):
    user_id: int
    reminders: list
    weekends: list


class ProfileUpdateRequest(BaseModel):
    user_id: int
    avatar_url: str = None
    nickname: str = None
    about: str = None
    goal: str = None
    telegram: str = None
    monthly_habits: str = None
    monthly_quote: str = None
