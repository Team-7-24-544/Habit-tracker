import json
from datetime import datetime

from telegram.ext import ContextTypes

from db import HabitTracking, SessionLocal
from bot import send_message_to_user

REMINDER_OFFSETS = [30, 15, 5, 0]


def get_all_reminders_for_today(weekday: str, ):
    db = SessionLocal()
    results = []

    habit_tracking_all = db.query(HabitTracking).all()
    for habit_tracking in habit_tracking_all:
        habit_name = habit_tracking.habit.name
        time_map = getattr(habit_tracking.habit, weekday)

        if time_map:
            parsed = json.loads(time_map)
            for start_time in parsed.keys():
                results.append((habit_tracking.user.chat_id, habit_name, start_time))

    db.close()
    return results


async def check_reminders(context: ContextTypes.DEFAULT_TYPE):
    now = datetime.now()
    weekday = now.strftime("%A").lower()

    reminders = get_all_reminders_for_today(weekday)
    CHECK_INTERVAL = 60

    REMINDER_OFFSETS = [30, 15, 5, 0]
    TOLERANCE = CHECK_INTERVAL / 60

    ...
    for chat_id, habit_name, start_time_str in reminders:
        try:
            start_time = datetime.strptime(start_time_str, "%H:%M").replace(
                year=now.year, month=now.month, day=now.day
            )
            delta = (start_time - now).total_seconds() / 60
            print(delta)
            for offset in REMINDER_OFFSETS:
                if offset - TOLERANCE <= delta <= offset + TOLERANCE:
                    text = f"Напоминание: «{habit_name}» начнётся в {start_time_str}"
                    await send_message_to_user(chat_id, text)
                    break
        except Exception as e:
            print(f"Ошибка при проверке напоминания: {e}")
