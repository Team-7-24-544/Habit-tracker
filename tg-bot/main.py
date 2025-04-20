from telegram.ext import Application, CommandHandler

from config import BOT_TOKEN
from bot import start
from scheduler import check_reminders


def run_bot():
    application = Application.builder().token(BOT_TOKEN).build()

    application.add_handler(CommandHandler("start", start))
    job_queue = application.job_queue
    job_queue.run_repeating(
        check_reminders,
        interval=30,
        first=10
    )
    application.run_polling()


if __name__ == "__main__":
    run_bot()
