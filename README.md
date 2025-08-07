# NXDF LLMOps - 종합 의료 관리 시스템

NXDF LLMOps는 **RAG(Retrieval-Augmented Generation) 기반 문서 검색 및 질의응답 시스템**과 **AI 기반 병원 관리 데스크톱 애플리케이션**을 포함한 종합 의료 관리 시스템입니다.

## 📋 프로젝트 개요

이 프로젝트는 다음과 같은 세 가지 주요 컴포넌트로 구성됩니다:

1. **clinic_back** - Django 백엔드 API 서버 (RAG 시스템)
2. **clinic_front** - Flutter 웹/모바일 프론트엔드
3. **dation_clinic_app** - Electron 데스크톱 애플리케이션 (AI 병원 관리 시스템)

## 🏗️ 프로젝트 구조

```
clinic_llmops/
├── clinic_back/                 # Django 백엔드 (RAG 시스템)
│   ├── apps/
│   │   ├── rag/                # RAG 관련 기능
│   │   └── user/               # 사용자 관리
│   ├── config/                 # Django 설정
│   ├── core/                   # 핵심 유틸리티
│   └── data/                   # 벡터 저장소 데이터
├── clinic_front/               # Flutter 프론트엔드
│   ├── lib/
│   │   ├── features/           # 기능별 모듈
│   │   ├── shared/             # 공통 컴포넌트
│   │   └── app/                # 앱 설정
│   └── web/                    # 웹 빌드
└── dation_clinic_app/          # Electron 데스크톱 앱
    ├── src/
    │   ├── components/         # React 컴포넌트
    │   ├── api/                # API 모듈
    │   └── utils/              # 유틸리티
    └── public/                 # 정적 파일
```

## 🛠️ 기술 스택

### Backend (clinic_back)
- **Framework**: Django 4.2.23
- **API**: Django REST Framework 3.15.2
- **Database**: SQLite (개발), PostgreSQL (운영)
- **Authentication**: JWT
- **AI/ML**: 
  - FAISS (벡터 검색)
  - Sentence Transformers (텍스트 임베딩)
  - FastText (텍스트 임베딩)
  - LangChain (문서 처리)
- **Storage**: Google Cloud Storage
- **CORS**: django-cors-headers

### Frontend (clinic_front)
- **Framework**: Flutter 3.32.8
- **State Management**: Flutter Bloc 9.1.0
- **Routing**: Go Router 16.0.0
- **HTTP Client**: Dio 5.8.0
- **Dependency Injection**: Get It 8.0.3
- **Code Generation**: JSON Serializable, Build Runner

### Desktop App (dation_clinic_app)
- **Framework**: React 18.2.0
- **Desktop**: Electron 31.0.2
- **Build Tool**: Vite 5.3.0
- **AI**: Google Generative AI (@google/generative-ai)
- **Markdown**: react-markdown + rehype-raw + remark-gfm
- **Package**: electron-builder

## 🚀 빠른 시작 (테스트용)

### 1. 백엔드 실행 (Django)

```bash
# clinic_back 디렉토리로 이동
cd clinic_back

# 가상환경 활성화
source venv/bin/activate

# 서버 실행
python manage.py runserver 0.0.0.0:8000
```

### 2. 프론트엔드 실행 (Flutter)

```bash
# clinic_front 디렉토리로 이동
cd clinic_front

# 의존성 설치
flutter pub get

# 웹 실행
flutter run -d chrome --web-port=3000
```

### 3. 데스크톱 앱 실행 (Electron)

```bash
# dation_clinic_app 디렉토리로 이동
cd dation_clinic_app

# 의존성 설치
npm install

# 개발 모드 실행
npm run electron:dev
```

### 4. 테스트 계정

- **이메일**: `test@example.com`
- **비밀번호**: `test1234`

## 📚 상세 설치 및 실행 가이드

### Backend 설치 (clinic_back)

#### 1. Python 환경 설정
```bash
cd clinic_back

# Python 3.8 이상 필요
python --version

# 가상환경 생성
python -m venv venv

# 가상환경 활성화
source venv/bin/activate  # macOS/Linux
# 또는
venv\Scripts\activate     # Windows
```

#### 2. 의존성 설치
```bash
pip install -r requirements.txt
```

#### 3. 데이터베이스 설정
```bash
# 마이그레이션 실행
python manage.py makemigrations
python manage.py migrate

# 테스트 사용자 생성
python manage.py shell
```

```python
from apps.user.models import User
from django.contrib.auth.hashers import make_password

# 테스트 사용자 생성
user = User.objects.create(
    email='test@example.com',
    name='테스트 사용자',
    password=make_password('test1234')
)
print(f"사용자 생성 완료: {user.email}")
exit()
```

#### 4. 서버 실행
```bash
python manage.py runserver 0.0.0.0:8000
```

### Frontend 설치 (clinic_front)

#### 1. Flutter 환경 설정
```bash
cd clinic_front

# Flutter 버전 확인
flutter --version

# 의존성 설치
flutter pub get
```

#### 2. 코드 생성
```bash
# JSON 직렬화 코드 생성
dart run build_runner build
```

#### 3. 앱 실행
```bash
# 웹 실행
flutter run -d chrome --web-port=3000

# 모바일 실행 (iOS)
flutter run -d ios

# 모바일 실행 (Android)
flutter run -d android
```

### Desktop App 설치 (dation_clinic_app)

#### 1. Node.js 환경 설정
```bash
cd dation_clinic_app

# Node.js 버전 확인
node --version
npm --version
```

#### 2. 의존성 설치
```bash
npm install
```

#### 3. 앱 실행
```bash
# 개발 모드 (Vite React)
npm run dev

# Electron 개발 모드
npm run electron:dev

# 프로덕션 빌드
npm run electron:build
```

## 🔧 API 문서

### 인증 API

#### 로그인
```http
POST /api/v1/users/login
Content-Type: application/json

{
  "email": "test@example.com",
  "password": "test1234"
}
```

#### 응답
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "user": {
    "id": "uuid",
    "name": "테스트 사용자",
    "email": "test@example.com"
  }
}
```

### RAG API

#### RAG 목록 조회
```http
GET /api/v1/rags
Authorization: Bearer {access_token}
```

#### RAG 생성
```http
POST /api/v1/rags
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "name": "RAG 이름",
  "description": "RAG 설명",
  "rag_file_ids": ["file-uuid-1", "file-uuid-2"]
}
```

#### 파일 업로드
```http
POST /api/v1/rags/file/upload
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

file: [파일]
```

#### RAG 검색
```http
POST /api/v1/rags/retriever/{rag_id}
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "query": "검색 질문"
}
```

## 🏛️ 아키텍처

### Backend Architecture (Clean Architecture)
```
Entity → Repository → Service → View
```

- **Entity**: 비즈니스 로직을 담은 도메인 객체
- **Repository**: 데이터 접근 계층
- **Service**: 비즈니스 로직 처리
- **View**: API 엔드포인트

### Frontend Architecture (Clean Architecture + BLoC)
```
Presentation → Domain → Data
```

- **Presentation**: UI 컴포넌트 및 BLoC
- **Domain**: 비즈니스 로직 및 엔티티
- **Data**: 데이터 소스 및 모델

### Desktop App Architecture (React + Electron)
```
React Components → API Layer → Electron Main Process
```

- **React Components**: UI 렌더링
- **API Layer**: Google AI 및 Mock API 연동
- **Electron Main Process**: 데스크톱 앱 관리

## 🔍 주요 기능

### 1. RAG 시스템 (clinic_back + clinic_front)
- **문서 업로드**: PDF, DOCX 등 다양한 형식 지원
- **벡터 검색**: FAISS를 이용한 고속 유사도 검색
- **질의응답**: 업로드된 문서 기반 AI 응답
- **API 제공**: RESTful API를 통한 외부 연동

### 2. 병원 관리 시스템 (dation_clinic_app)
- **AI 챗봇**: Google Gemini AI 기반 대화형 인터페이스
- **환자 관리**: EMR 데이터 관리
- **예약 시스템**: 환자 예약 관리
- **수술 기록**: 수술 관련 데이터 관리
- **CRM 시스템**: 고객 관계 관리
- **설문조사**: 환자 만족도 조사

### 3. 통합 기능
- **멀티 플랫폼**: 웹, 모바일, 데스크톱 지원
- **실시간 로그**: API 호출 상태 모니터링
- **세션 관리**: 대화 세션 저장/불러오기
- **데이터 동기화**: 클라우드 기반 데이터 관리

## 🚀 배포

### Backend 배포
```bash
# 프로덕션 설정
export DJANGO_SETTINGS_MODULE=config.settings_prod

# 데이터베이스 마이그레이션
python manage.py migrate

# 정적 파일 수집
python manage.py collectstatic

# Gunicorn 실행
gunicorn config.wsgi:application --bind 0.0.0.0:8000
```

### Frontend 배포
```bash
# 웹 빌드
flutter build web

# 배포 디렉토리: build/web/
```

### Desktop App 배포
```bash
# 프로덕션 빌드
npm run electron:build

# 배포 파일: release/ 디렉토리
```

## 🐛 문제 해결

### 일반적인 문제들

#### 1. Python 가상환경 문제
```bash
# 가상환경 재생성
rm -rf venv
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

#### 2. Flutter 의존성 문제
```bash
# 캐시 정리
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

#### 3. Node.js 의존성 문제
```bash
# node_modules 재설치
rm -rf node_modules package-lock.json
npm install
```

#### 4. 포트 충돌
```bash
# 사용 중인 포트 확인
lsof -i :8000  # 백엔드
lsof -i :3000  # 프론트엔드
```

### 로그 확인

#### Backend 로그
```bash
# Django 로그 확인
tail -f clinic_back/django.log

# 서버 로그 확인
python manage.py runserver 0.0.0.0:8000 --verbosity=2
```

#### Frontend 로그
```bash
# Flutter 로그 확인
flutter logs

# 웹 브라우저 개발자 도구
# Console 탭에서 에러 확인
```

## 📝 개발 가이드

### 코드 스타일

#### Python (Backend)
- PEP 8 준수
- Type hints 사용
- Docstring 작성

#### Dart (Frontend)
- Effective Dart 가이드라인 준수
- BLoC 패턴 사용
- Clean Architecture 적용

#### JavaScript/React (Desktop App)
- ESLint 규칙 준수
- React Hooks 사용
- 컴포넌트 분리

### 테스트

#### Backend 테스트
```bash
# 단위 테스트
python manage.py test

# 특정 앱 테스트
python manage.py test apps.rag
```

#### Frontend 테스트
```bash
# 단위 테스트
flutter test

# 위젯 테스트
flutter test test/widget_test.dart
```

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 🤝 기여

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 지원

문제가 발생하거나 질문이 있으시면 이슈를 생성해 주세요.

---

**NXDF LLMOps** - 의료 업무 자동화와 AI 기반 의사결정 지원을 위한 종합적인 의료 관리 시스템 