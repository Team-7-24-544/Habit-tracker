import secrets
import jwt
from fastapi import HTTPException

SECRET_KEY = secrets.token_urlsafe(32)


def check_token(token, user_id):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=["HS256"])
        user_id_from_token = payload.get("username").split()[0]
        if user_id_from_token != str(user_id):
            raise HTTPException(status_code=403, detail="User ID does not match token")

    except jwt.PyJWTError:
        raise HTTPException(status_code=403, detail="Invalid or expired token")
