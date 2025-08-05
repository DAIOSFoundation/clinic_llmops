# NXDF LLMOPS - RAG 기반 문서 검색 및 질의응답 시스템

## 📋 프로젝트 개요

NXDF LLMOPS는 RAG(Retrieval-Augmented Generation) 기술을 활용한 문서 검색 및 질의응답 시스템입니다. 사용자가 문서를 업로드하고, AI 모델을 통해 문서 내용을 기반으로 한 질의응답을 제공합니다.

### 🎯 주요 기능

- **사용자 인증**: JWT 기반 로그인/회원가입
- **문서 업로드**: 다양한 형식의 문서 업로드 지원
- **RAG 시스템**: FAISS 벡터 검색과 Sentence Transformers를 활용한 문서 검색
- **질의응답**: 업로드된 문서를 기반으로 한 AI 질의응답
- **웹 인터페이스**: Flutter 웹 기반의 현대적인 UI/UX

## 🏗️ 프로젝트 구조

```
clinic_llmops/
├── clinic_back/                 # Django 백엔드
│   ├── apps/
│   │   ├── user/               # 사용자 관리 앱
│   │   │   ├── entities/       # 도메인 엔티티
│   │   │   ├── models/         # Django 모델
│   │   │   ├── repositories/   # 데이터 접근 계층
│   │   │   ├── serializers/    # API 직렬화
│   │   │   ├── services/       # 비즈니스 로직
│   │   │   ├── views/          # API 뷰
│   │   │   └── urls.py         # URL 라우팅
│   │   └── rag/                # RAG 시스템 앱
│   │       ├── entities/       # RAG 엔티티
│   │       ├── infra/          # 인프라 (FAISS, FastText)
│   │       ├── models/         # RAG 모델
│   │       ├── repositories/   # RAG 데이터 접근
│   │       ├── serializers/    # RAG API 직렬화
│   │       ├── services/       # RAG 비즈니스 로직
│   │       ├── views/          # RAG API 뷰
│   │       └── urls.py         # RAG URL 라우팅
│   ├── config/                 # Django 설정
│   │   ├── settings.py         # 프로젝트 설정
│   │   └── urls.py             # 메인 URL 설정
│   ├── core/                   # 공통 기능
│   │   ├── constants/          # 상수 정의
│   │   ├── exceptions/         # 예외 처리
│   │   ├── middleware/         # 미들웨어
│   │   └── utils/              # 유틸리티
│   ├── data/                   # 데이터 저장소
│   │   └── rag/                # RAG 인덱스 파일
│   ├── models/                 # AI 모델 저장소
│   ├── requirements.txt        # Python 의존성
│   └── manage.py               # Django 관리 명령
│
└── clinic_front/               # Flutter 프론트엔드
    ├── lib/
    │   ├── app/                # 앱 설정
    │   │   ├── app.dart        # 메인 앱 위젯
    │   │   ├── app_env.dart    # 환경 설정
    │   │   └── app_router.dart # 라우팅 설정
    │   ├── core/               # 공통 기능
    │   │   ├── blocs/          # 인증 BLoC
    │   │   └── entities/       # 공통 엔티티
    │   ├── data/               # 데이터 계층
    │   │   ├── mappers/        # 데이터 매핑
    │   │   ├── models/         # API 모델
    │   │   └── network/        # 네트워크 서비스
    │   ├── features/           # 기능별 모듈
    │   │   ├── home/           # 홈 화면
    │   │   │   ├── presentation/ # UI 컴포넌트
    │   │   │   └── rag/        # RAG 기능
    │   │   │       ├── data/   # RAG 데이터 계층
    │   │   │       ├── domain/ # RAG 도메인 계층
    │   │   │       └── presentation/ # RAG UI
    │   │   └── login/          # 로그인 기능
    │   │       ├── data/       # 로그인 데이터 계층
    │   │       ├── domain/     # 로그인 도메인 계층
    │   │       ├── presentation/ # 로그인 UI
    │   │       └── signup/     # 회원가입
    │   ├── shared/             # 공유 컴포넌트
    │   │   ├── constants/      # 상수
    │   │   ├── exceptions/     # 예외 처리
    │   │   ├── presentation/   # 공통 UI 위젯
    │   │   ├── services/       # 공통 서비스
    │   │   ├── theme/          # 테마 설정
    │   │   └── utils/          # 유틸리티
    │   ├── injection.dart      # 의존성 주입
    │   └── main.dart           # 앱 진입점
    ├── assets/                 # 정적 자산
    │   ├── fonts/              # 폰트 파일
    │   ├── icons/              # 아이콘 파일
    │   └── images/             # 이미지 파일
    ├── pubspec.yaml            # Flutter 의존성
    └── web/                    # 웹 설정
        ├── index.html          # HTML 템플릿
        └── manifest.json       # PWA 매니페스트
```

## 🛠️ 기술 스택

### 백엔드 (Django)
- **Framework**: Django 4.2.23, Django REST Framework 3.15.2
- **Database**: SQLite (개발용), PostgreSQL (프로덕션용)
- **Authentication**: JWT (JSON Web Tokens)
- **AI/ML**: 
  - FAISS (벡터 검색)
  - Sentence Transformers (텍스트 임베딩)
  - FastText (텍스트 임베딩)
- **File Storage**: Google Cloud Storage
- **Document Processing**: LangChain
- **CORS**: django-cors-headers

### 프론트엔드 (Flutter)
- **Framework**: Flutter 3.32.8
- **State Management**: Flutter Bloc 9.1.0
- **Routing**: Go Router 16.0.0
- **HTTP Client**: Dio 5.8.0
- **Dependency Injection**: Get It 8.0.3
- **Local Storage**: Shared Preferences 2.2.2
- **File Handling**: File Picker 10.1.9, Desktop Drop 0.6.0
- **Charts**: FL Chart 1.0.0
- **Code Generation**: JSON Serializable 6.9.5, Build Runner 2.5.4

## 🚀 설치 및 실행

### 사전 요구사항

- **Python**: 3.8 이상
- **Flutter**: 3.32.8 이상
- **Node.js**: 18 이상 (Flutter 웹 개발용)
- **Git**: 최신 버전

### 1. 프로젝트 클론

```bash
git clone <repository-url>
cd clinic_llmops
```

### 2. 백엔드 설정

#### 2.1 가상환경 생성 및 활성화

```bash
cd clinic_back
python -m venv venv
source venv/bin/activate  # macOS/Linux
# 또는
venv\Scripts\activate     # Windows
```

#### 2.2 의존성 설치

```bash
pip install -r requirements.txt
```

#### 2.3 데이터베이스 마이그레이션

```bash
python manage.py makemigrations
python manage.py migrate
```

#### 2.4 테스트 사용자 생성

```bash
python create_test_user.py
```

#### 2.5 개발 서버 실행

```bash
python manage.py runserver 0.0.0.0:8000
```

### 3. 프론트엔드 설정

#### 3.1 의존성 설치

```bash
cd ../clinic_front
flutter pub get
```

#### 3.2 코드 생성

```bash
dart run build_runner build --delete-conflicting-outputs
```

#### 3.3 웹 서버 실행

```bash
flutter run -d chrome --web-port 3000
```

## 🧪 테스트

### 백엔드 API 테스트

#### 로그인 테스트
```bash
# Basic Auth를 사용한 로그인
curl -X POST http://localhost:8000/api/v1/users/login \
  -H "Authorization: Basic $(echo -n 'test@example.com:test1234' | base64)" \
  -H "Content-Type: application/json"
```

#### 회원가입 테스트
```bash
curl -X POST http://localhost:8000/api/v1/users/register \
  -H "Authorization: Basic $(echo -n 'newuser@example.com:newpassword123' | base64)" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "새 사용자",
    "email": "newuser@example.com",
    "password": "newpassword123"
  }'
```

#### RAG API 테스트
```bash
# RAG 목록 조회 (인증 필요)
curl -X GET http://localhost:8000/api/v1/rags \
  -H "Authorization: Bearer <access_token>"
```

### 프론트엔드 테스트

#### Flutter 테스트 실행
```bash
cd clinic_front
flutter test
```

#### 웹 브라우저 테스트
1. 브라우저에서 `http://localhost:3000` 접속
2. 테스트 계정으로 로그인:
   - 이메일: `test@example.com`
   - 비밀번호: `test1234`
3. RAG 기능 테스트

## 📚 API 문서

### 인증 API

#### 로그인
- **URL**: `POST /api/v1/users/login`
- **인증**: Basic Auth
- **요청 예시**:
```bash
curl -X POST http://localhost:8000/api/v1/users/login \
  -H "Authorization: Basic $(echo -n 'email:password' | base64)"
```

#### 회원가입
- **URL**: `POST /api/v1/users/register`
- **인증**: Basic Auth
- **요청 본문**:
```json
{
  "name": "사용자명",
  "email": "user@example.com",
  "password": "password123"
}
```

#### 토큰 갱신
- **URL**: `POST /api/v1/users/refresh`
- **인증**: Bearer Token (refresh_token)

### RAG API

#### RAG 목록 조회
- **URL**: `GET /api/v1/rags`
- **인증**: Bearer Token

#### RAG 상세 조회
- **URL**: `GET /api/v1/rags/{id}`
- **인증**: Bearer Token

#### RAG 생성
- **URL**: `POST /api/v1/rags`
- **인증**: Bearer Token
- **요청 본문**:
```json
{
  "name": "RAG 이름",
  "description": "RAG 설명",
  "rag_file_ids": ["file_id_1", "file_id_2"]
}
```

#### RAG 수정
- **URL**: `PATCH /api/v1/rags/{id}`
- **인증**: Bearer Token

#### RAG 삭제
- **URL**: `DELETE /api/v1/rags/{id}`
- **인증**: Bearer Token

#### 파일 업로드
- **URL**: `POST /api/v1/rags/file/upload`
- **인증**: Bearer Token
- **Content-Type**: `multipart/form-data`

#### 벡터 검색
- **URL**: `POST /api/v1/rags/retriever/{name}`
- **인증**: Bearer Token
- **요청 본문**:
```json
{
  "query": "검색할 질문",
  "k": 5
}
```

## 🏛️ 아키텍처

### 백엔드 아키텍처 (Clean Architecture)

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   API Views     │  │   Serializers   │  │  Middleware │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │    Entities     │  │    Services     │  │  Use Cases  │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Data Layer                              │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │  Repositories   │  │     Models      │  │  Infra      │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 프론트엔드 아키텍처 (Clean Architecture + BLoC)

```
┌─────────────────────────────────────────────────────────────┐
│                  Presentation Layer                         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │     Screens     │  │     Widgets     │  │    BLoCs    │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │    Entities     │  │   Use Cases     │  │ Repositories│ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Data Layer                              │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Data Sources  │  │     Models      │  │   Mappers   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## 🔧 개발 환경 설정

### 환경 변수 설정

#### 백엔드 (.env)
```env
SECRET_KEY=your-secret-key
REDIS_URL=redis://localhost:6379
GOOGLE_CLOUD_STORAGE_BUCKET=your-bucket-name
GOOGLE_APPLICATION_CREDENTIALS=path/to/service-account.json
```

#### 프론트엔드 (app_env.dart)
```dart
static const _baseURLs = {
  AppEnvironment.DEV: 'http://localhost:8000',
  AppEnvironment.PROD: 'https://your-api-domain.com',
};
```

### 데이터베이스 설정

#### 개발용 (SQLite)
```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": os.path.join(BASE_DIR, "db.sqlite3"),
    }
}
```

#### 프로덕션용 (PostgreSQL)
```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "your_db_name",
        "USER": "your_db_user",
        "PASSWORD": "your_db_password",
        "HOST": "your_db_host",
        "PORT": "5432",
    }
}
```

## 🚀 배포

### 백엔드 배포 (Docker)

```dockerfile
FROM python:3.8-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "config.wsgi:application"]
```

### 프론트엔드 배포

```bash
# 웹 빌드
flutter build web

# Firebase Hosting 배포
firebase deploy
```

## 🐛 문제 해결

### 일반적인 문제들

#### 1. 의존성 충돌
```bash
# 백엔드
pip install --upgrade pip
pip install -r requirements.txt --force-reinstall

# 프론트엔드
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

#### 2. 데이터베이스 마이그레이션 오류
```bash
python manage.py makemigrations --empty app_name
python manage.py makemigrations
python manage.py migrate
```

#### 3. 포트 충돌
```bash
# 포트 사용 확인
lsof -i :8000
lsof -i :3000

# 프로세스 종료
kill -9 <PID>
```

#### 4. Flutter 웹 캐시 문제
```bash
flutter clean
flutter pub get
flutter run -d chrome --web-port 3000
```

## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 문의

프로젝트에 대한 문의사항이 있으시면 이슈를 생성해주세요.

---

**NXDF LLMOPS** - RAG 기반 문서 검색 및 질의응답 시스템 