import asyncio
import logging
from datetime import datetime

from redis import Redis
from telegram import Update, ReplyKeyboardRemove, InlineKeyboardMarkup, InlineKeyboardButton
from telegram.ext import (
    ContextTypes,
    CommandHandler,
    ConversationHandler,
    CallbackQueryHandler,
    MessageHandler,
    filters, Application
)

from db import SessionLocal, User, UserSettings
from scheduler import is_weekend_today

logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)
logger = logging.getLogger(__name__)

LOGIN_INPUT = 1

redis = Redis(host="localhost", port=6379, decode_responses=True)


async def worker(app: Application):
    """Фоновая задача, проверяет очередь."""
    db = SessionLocal()
    while True:
        task = redis.blpop(["message_queue"], timeout=10 * 60)
        if task:
            chat_id, text = task[1].split(":", 1)
            chat_id = int(chat_id)
            user = db.query(User).filter_by(chat_id=chat_id).first()
            user_settings = db.query(UserSettings).filter_by(user_id=user.id).first()
            if user_settings and not is_weekend_today(user_settings.weekends, datetime.now()):
                await app.bot.send_message(chat_id=chat_id, text=text)
        await asyncio.sleep(1)


async def start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> int:
    """Обработка команды /start"""
    session = SessionLocal()
    try:
        tg_user = update.effective_user
        user = session.query(User).filter_by(tg_name=tg_user.username).first()

        if user:
            if user.tg_checked and user.chat_id:
                await update.message.reply_text(
                    f"🔒 Ваш аккаунт уже привязан к логину: {user.login}",
                    reply_markup=ReplyKeyboardRemove()
                )
                return ConversationHandler.END

            # Сохраняем данные пользователя для проверки
            context.user_data["tg_username"] = tg_user.username
            context.user_data["user_id"] = user.id

            # Отправляем запрос логина с кнопкой отмены
            await update.message.reply_text(
                "🔑 Введите ваш логин с сайта для привязки аккаунта:",
                reply_markup=InlineKeyboardMarkup([
                    [InlineKeyboardButton("❌ Отменить", callback_data="cancel")]
                ])
            )
            return LOGIN_INPUT

        else:
            await update.message.reply_text(
                "👋 Привет!\n\n"
                "Это телеграм-бот для трекера привычек.\n"
                "Для работы с ботом необходимо зарегистрироваться на сайте:\n"
                "[HabitTracker.com](https://www.example.com)",
                parse_mode="Markdown",
                disable_web_page_preview=True,
                reply_markup=ReplyKeyboardRemove()
            )
            return ConversationHandler.END

    except Exception as e:
        logger.error(f"Error in start handler: {e}")
        await update.message.reply_text(
            "⚠️ Произошла ошибка. Пожалуйста, попробуйте позже.",
            reply_markup=ReplyKeyboardRemove()
        )
        return ConversationHandler.END
    finally:
        session.close()


async def handle_login(update: Update, context: ContextTypes.DEFAULT_TYPE) -> int:
    """Обработка введенного логина"""
    session = SessionLocal()
    try:
        login = update.message.text.strip()
        user = session.query(User).filter_by(login=login).first()

        # Проверяем существование пользователя
        if not user:
            await update.message.reply_text(
                "❌ Логин не найден. Попробуйте еще раз:"
            )
            return LOGIN_INPUT

        # Проверяем соответствие Telegram-аккаунтов
        if user.tg_name.lower() != context.user_data["tg_username"].lower():
            await update.message.reply_text(
                f"⚠️ Несоответствие Telegram-аккаунтов!\n"
                f"В базе: {user.tg_name}\n"
                f"Ваш: {context.user_data['tg_username']}\n\n"
                "Попробуйте еще раз:",
                reply_markup=InlineKeyboardMarkup([
                    [InlineKeyboardButton("❌ Отменить", callback_data="cancel")]
                ])
            )
            return LOGIN_INPUT

        # Обновляем данные пользователя
        user.tg_checked = True
        user.chat_id = update.effective_chat.id
        session.commit()

        await update.message.reply_text(
            "✅ Аккаунт успешно привязан!",
            reply_markup=ReplyKeyboardRemove()
        )

        return ConversationHandler.END

    except Exception as e:
        logger.error(f"Error in login handler: {e}")
        await update.message.reply_text(
            "⚠️ Произошла ошибка. Пожалуйста, попробуйте позже.",
            reply_markup=ReplyKeyboardRemove()
        )
        return ConversationHandler.END
    finally:
        session.close()


async def cancel(update: Update, context: ContextTypes.DEFAULT_TYPE) -> int:
    """Обработка отмены действия"""
    query = update.callback_query
    try:
        if query:
            await query.answer()
            await query.edit_message_text(
                "❌ Действие отменено",
                reply_markup=None
            )
        else:
            await update.message.reply_text(
                "❌ Действие отменено",
                reply_markup=ReplyKeyboardRemove()
            )
    except Exception as e:
        logger.error(f"Error in cancel handler: {e}")

    context.user_data.clear()
    return ConversationHandler.END


def setup_handlers(application: Application):
    """Настройка обработчиков команд"""
    conv_handler = ConversationHandler(
        entry_points=[CommandHandler("start", start)],
        states={
            LOGIN_INPUT: [
                MessageHandler(filters.TEXT & ~filters.COMMAND, handle_login),
                CallbackQueryHandler(cancel, pattern="^cancel$")
            ],
        },
        fallbacks=[
            CommandHandler("start", start),
            CallbackQueryHandler(cancel, pattern="^cancel$")
        ],
        allow_reentry=True
    )

    application.add_handler(conv_handler)
