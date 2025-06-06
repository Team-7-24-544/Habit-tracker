import asyncio

from telegram.ext import Application

from bot import setup_handlers, worker
from bot_token import BOT_TOKEN
from config import TIME_PERIOD
from scheduler import check_reminders


def run_bot():
    try:
        application = Application.builder().token(BOT_TOKEN).build()
    except:
        print("Неверный токен для телеграм-бота (см. bot_token.py)")
        return

    setup_handlers(application)
    job_queue = application.job_queue
    job_queue.run_repeating(
        callback=check_reminders,
        interval=TIME_PERIOD * 1.0,
        first=10.0,
    )
    job_queue.run_once(
        lambda ctx: asyncio.create_task(worker(ctx.application)),
        when=1
    )
    application.run_polling()


if __name__ == "__main__":
    run_bot()
