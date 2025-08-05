import os

# Django
os.environ.setdefault('SECRET_KEY', 'django-insecure-test-key-for-development-only')
os.environ.setdefault('DEBUG', 'True')

# Database (SQLite 사용)
# os.environ.setdefault('DB_NAME', 'clinic_llmops')
# os.environ.setdefault('DB_USER', 'your_db_user')
# os.environ.setdefault('DB_PASSWORD', 'your_db_password')
# os.environ.setdefault('DB_HOST', 'localhost')
# os.environ.setdefault('DB_PORT', '5432')

# Google Cloud Storage (테스트용)
# os.environ.setdefault('GOOGLE_APPLICATION_CREDENTIALS', 'path/to/service-account.json')
# os.environ.setdefault('GCS_BUCKET_NAME', 'your_bucket_name')

# Redis (선택사항)
# os.environ.setdefault('REDIS_URL', 'redis://localhost:6379') 