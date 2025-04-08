import asyncio

from telegram import Update, Bot
from telegram.ext import ContextTypes
from config import BOT_TOKEN
from db import SessionLocal, User

bot = Bot(token=BOT_TOKEN)


async def send_message_to_user(chat_id: int, text: str):
    try:
        await bot.send_message(chat_id, text)
    except Exception as e:
        print(f"Error sending message: {e}")


async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    session = SessionLocal()
    tg_username = update.message.from_user.username
    user = session.query(User).filter_by(tg_name=tg_username).first()
    if user:
        user.tg_checked = True
        user.chat_id = update.message.chat_id
        session.commit()
        await update.message.reply_text("Telegram успешно привязан к аккаунту на сайте.")
    else:
        await update.message.reply_text("Не удалось найти пользователя с таким Telegram.")

    session.close()
