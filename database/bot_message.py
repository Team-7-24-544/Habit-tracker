from redis import Redis
from sqlalchemy.orm import Session

from models import User

redis = Redis(host="localhost", port=6379, decode_responses=True)


# queue = Queue("telegram_queue", connection=redis)


def add_message(user_id: int, message: str, db: Session):
    user = db.query(User).where(User.id == user_id).first()
    if user and user.chat_id != -1:
        redis.rpush("message_queue", f"{user.chat_id}:{message}")
