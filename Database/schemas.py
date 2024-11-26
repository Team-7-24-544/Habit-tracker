from pydantic import BaseModel
from datetime import date


# Базовая схема для HabitEntry
class HabitEntryBase(BaseModel):
    date: date
    completed: bool


# Схема для создания HabitEntry
class HabitEntryCreate(HabitEntryBase):
    pass


# Схема для ответа на запрос HabitEntry
class HabitEntry(HabitEntryBase):
    id: int
    habit_id: int

    class Config:
        from_attributes = True


# Остальные схемы
class HabitBase(BaseModel):
    title: str
    start_date: date


class HabitCreate(HabitBase):
    pass


class Habit(HabitBase):
    id: int
    entries: list[HabitEntryBase] = []

    class Config:
        from_attributes = True
