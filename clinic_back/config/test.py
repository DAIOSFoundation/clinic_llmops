import os
import sys
import django
from django.db import connections
from django.db.utils import OperationalError
from dotenv import load_dotenv

# 루트 경로를 PYTHONPATH에 추가 (문제 방지용)
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# .env 로드
load_dotenv(
    dotenv_path=os.path.join(os.path.dirname(os.path.dirname(__file__)), ".env")
)

# Django settings 지정
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

# Django 초기화
django.setup()


# 데이터베이스 연결 테스트
def test_database_connection():
    try:
        db_conn = connections["default"]
        db_conn.cursor()
        print("✅ DATABASE 연결 성공")
    except OperationalError as e:
        print("❌ DATABASE 연결 실패:", e)
    finally:
        db_conn.close()


if __name__ == "__main__":
    test_database_connection()
