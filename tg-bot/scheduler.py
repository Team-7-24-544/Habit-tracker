import json

from telegram.ext import CallbackContext

from config import TIME_PERIOD
from db import HabitTracking, SessionLocal, UserSettings


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
                results.append((habit_tracking.user.chat_id, habit_tracking.user.id, habit_name, start_time))

    db.close()
    return results


from datetime import datetime, timedelta


def check_time(
        user_id: int,
        start_time: datetime.time
) -> bool:
    now = datetime.now()
    db = SessionLocal()
    if start_time <= now.time():
        return False

    user_settings = db.query(UserSettings).filter_by(user_id=user_id).first()
    if not user_settings:
        return False

    if is_weekend_today(user_settings.weekends, now):
        return False

    for reminder_minutes in json.loads(user_settings.reminders):
        start = datetime(now.year, now.month, now.day, start_time.hour, start_time.minute)
        reminder_time = start - timedelta(minutes=int(reminder_minutes))
        if (reminder_time - timedelta(minutes=TIME_PERIOD // 2 // 60)) <= now <= (
                reminder_time + timedelta(minutes=TIME_PERIOD // 2 // 60)):
            print(reminder_minutes, start_time, reminder_time - timedelta(minutes=5), now,
                  reminder_time + timedelta(minutes=TIME_PERIOD // 2 // 60))
            return True

    return False


def is_weekend_today(weekends_data: str, now: datetime) -> bool:
    if not weekends_data:
        return False

    weekends = json.loads(weekends_data)

    current_weekday = now.weekday()
    current_time = now.time()
    for day_schedule in weekends:
        day_name = day_schedule['day']

        if day_name == str(current_weekday):
            start_time = datetime.strptime(day_schedule['start'], "%H:%M").time()
            end_time = datetime.strptime(day_schedule['end'], "%H:%M").time()

            if start_time and end_time:

                if start_time <= current_time <= end_time:
                    return True

    return False


async def check_reminders(context: CallbackContext):
    now = datetime.now()
    weekday = now.strftime("%A").lower()

    reminders = get_all_reminders_for_today(weekday)

    for chat_id, user_id, habit_name, start_time_str in reminders:
        if check_time(user_id, datetime.strptime(start_time_str, '%H:%M').time()):
            text = f"Напоминание: «{habit_name}» начнётся в {start_time_str}"
            await context.bot.send_message(chat_id=chat_id, text=text)
