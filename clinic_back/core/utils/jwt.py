from datetime import datetime, timedelta, timezone
import jwt
from config import settings


SECRET_KEY = settings.SECRET_KEY
ALGORITHM = "HS256"


ACCESS_TOKEN_EXPIRE = 60 * 24 * 30  # 1달 (30일)
REFRESH_TOKEN_EXPIRE = 60 * 24 * 60  # 2달 (60일)


def create_access_token(data: dict):
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


def create_refresh_token(data: dict):
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=REFRESH_TOKEN_EXPIRE)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def verify_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except jwt.ExpiredSignatureError:
        return None
    except jwt.JWTError:
        return None


def refresh_access_token(refresh_token: str):
    try:
        payload = jwt.decode(refresh_token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = payload.get("sub")
        if user_id is None:
            return None
        
        # 새로운 access token 생성
        access_token = create_access_token(data={"sub": user_id})
        return access_token
    except jwt.ExpiredSignatureError:
        return None
    except jwt.JWTError:
        return None
