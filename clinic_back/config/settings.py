from dotenv import load_dotenv
import os
from google.oauth2 import service_account


load_dotenv()

TIME_ZONE = "UTC"
DEFAULT_CHARSET = "utf-8"
DEBUG = False

# 언어 및 인코딩 설정
LANGUAGE_CODE = "ko-kr"
USE_I18N = True
USE_L10N = True
USE_TZ = True

# 파일 업로드 인코딩
FILE_UPLOAD_ENCODING = "utf-8"

# 한글 URL 처리 설정
DEFAULT_AUTO_FIELD = "django.db.models.BigAutoField"

# WSGI 서버 설정
WSGI_APPLICATION = "config.wsgi.application"

# Channels 설정
ASGI_APPLICATION = "config.asgi.application"

# Channel Layers 설정 (Redis 사용)
CHANNEL_LAYERS = {
    "default": {
        "BACKEND": "channels.layers.InMemoryChannelLayer",
    }
}

ALLOWED_HOSTS = ["*"]


CORS_ALLOW_ALL_ORIGINS = True
# CORS_ALLOWED_ORIGINS = [
#     "https://dation-app-demo.web.app",
# ]
INSTALLED_APPS = [
    "corsheaders",
]

MIDDLEWARE = [
    "corsheaders.middleware.CorsMiddleware",
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
    "core.middleware.jwt_auth.JWTAuthMiddleware",
    "core.middleware.wrap_response.WrapResponseMiddleware",
]

INSTALLED_APPS = [
    "core.apps.CoreConfig",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "rest_framework",
    "storages",
    "apps.user",
    "apps.rag",
    "channels",
]
REST_FRAMEWORK = {
    "EXCEPTION_HANDLER": "core.exceptions.exception_handler.base_exception_handler",
    "DEFAULT_AUTHENTICATION_CLASSES": [],
    "DEFAULT_PERMISSION_CLASSES": ["rest_framework.permissions.AllowAny"],
}

ROOT_URLCONF = "config.urls"

# ENV
SECRET_KEY = os.getenv("SECRET_KEY", "django-insecure-test-key-for-development-only")
REDIS_URL = os.getenv("REDIS_URL")


# PATH
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Database
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": os.path.join(BASE_DIR, "db.sqlite3"),
    }
}

# Data 파일 경로
DATA_DIR = os.path.join(BASE_DIR, "data")

# RAG 인덱스 파일 경로
RAG_FAISS_INDEX_PATH = os.path.join(DATA_DIR, "rag")

# FasetText 모델 경로
MODEL_DIR = os.path.join(BASE_DIR, "models")

# FastText 모델 이름 (온라인 사용)
FASTTEXT_MODEL = "cc.ko.300.bin"

# Sentence Transformer 모델
SENTENCE_TRANSFORMER_MODEL = "sentence-transformers/paraphrase-multilingual-mpnet-base-v2"


# Log
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "verbose": {
            "format": "{levelname} {asctime} {module} {process:d} {thread:d} {message}",
            "style": "{",
        },
        "simple": {
            "format": "{levelname} {message}",
            "style": "{",
        },
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "formatter": "simple",
        },
        "websocket": {
            "class": "core.utils.websocket_log_handler.WebSocketLogHandler",
            "formatter": "simple",
        },
    },
    "loggers": {
        "django": {
            "handlers": [
                "console",
            ],
            "level": "INFO",
            "propagate": False,
        },
        "apps": {
            "handlers": [
                "console",
                "websocket",
            ],
            "level": "INFO",
            "propagate": False,
        },
    },
    "root": {
        "handlers": [
            "console",
        ],
        "level": "WARNING",
    },
}
