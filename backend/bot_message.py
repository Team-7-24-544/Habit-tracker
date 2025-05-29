import logging

from redis import Redis
from sqlalchemy.orm import Session

from models import User

redis = Redis(host="localhost", port=6379, decode_responses=True)
logger = logging.getLogger("info_logger")
errors = logging.getLogger("error_logger")


def add_message(user_id: int, message: str, db: Session):
    try:
        user = db.query(User).where(User.id == user_id).first()
        if user and user.chat_id != -1:
            redis.rpush("message_queue", f"{user.chat_id}:{message}")
    except Exception as e:
        errors.error("Error while sending message", e)
