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
    login: str = None,
    password: str = None
    tg_nick: str = None


class SetMarkRequest(BaseModel):
    user_id: int
    habit_id: int
