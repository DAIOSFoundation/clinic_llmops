# Tox&Feel - AI 기반 의료 관리 시스템

Tox&Feel는 **RAG(Retrieval-Augmented Generation) 기반 문서 검색 및 질의응답 시스템**과 **AI 기반 병원 관리 데스크톱 애플리케이션**을 포함한 종합 의료 관리 시스템입니다.

## 📋 프로젝트 개요

이 프로젝트는 다음과 같은 세 가지 주요 컴포넌트로 구성됩니다:

1. **clinic_back** - Django 백엔드 API 서버 (RAG 시스템)
2. **clinic_front** - Flutter 웹/모바일 프론트엔드 (RAG 관리)
3. **dation_clinic_app** - Electron 데스크톱 애플리케이션 (Tox&Feel AI 병원 관리 시스템)

## 🏗️ 프로젝트 구조

```
clinic_llmops/
├── clinic_back/                 # Django 백엔드 (RAG 시스템)
│   ├── apps/
│   │   ├── rag/                # RAG 관련 기능
│   │   │   ├── entities/       # RAG 엔티티
│   │   │   ├── infra/          # FAISS, Ollama 인프라
│   │   │   ├── models/         # Django 모델
│   │   │   ├── repositories/   # 데이터 접근 계층
│   │   │   ├── serializers/    # API 직렬화
│   │   │   ├── services/       # 비즈니스 로직
│   │   │   └── views/          # API 엔드포인트
│   │   └── user/               # 사용자 관리
│   ├── config/                 # Django 설정
│   ├── core/                   # 핵심 유틸리티
│   └── data/                   # 벡터 저장소 데이터
├── clinic_front/               # Flutter 프론트엔드
│   ├── lib/
│   │   ├── features/           # 기능별 모듈
│   │   │   ├── home/           # 홈 화면
│   │   │   │   └── rag/        # RAG 관리 기능
│   │   │   └── login/          # 로그인/회원가입
│   │   ├── shared/             # 공통 컴포넌트
│   │   └── app/                # 앱 설정
│   └── web/                    # 웹 빌드
└── dation_clinic_app/          # Electron 데스크톱 앱 (Tox&Feel)
    ├── src/
    │   ├── components/         # React 컴포넌트
    │   │   ├── RagSettingsPage.jsx  # RAG API 설정
    │   │   ├── MainContent.jsx      # 메인 콘텐츠
    │   │   └── InteractionPage.jsx  # 상호작용 페이지
    │   ├── api/                # API 모듈
    │   └── utils/              # 유틸리티
    │       ├── ragApiManager.js     # RAG API 관리
    │       └── geminiApi.js         # Gemini AI 연동
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
  - Ollama (로컬 LLM - Gemma2:2b)
  - LangChain (문서 처리)
  - **KoNLPy** (한국어 형태소 분석)
- **Storage**: Google Cloud Storage
- **CORS**: django-cors-headers
- **WebSocket**: Django Channels (실시간 로그 전송)

### Frontend (clinic_front)
- **Framework**: Flutter 3.32.8
- **State Management**: Flutter Bloc 9.1.0
- **Routing**: Go Router 16.0.0
- **HTTP Client**: Dio 5.8.0
- **Dependency Injection**: Get It 8.0.3
- **Code Generation**: JSON Serializable, Build Runner

### Desktop App (dation_clinic_app - Tox&Feel)
- **Framework**: React 18.2.0
- **Desktop**: Electron 31.0.2
- **Build Tool**: Vite 5.3.0
- **AI**: Ollama Gemma3:27b (로컬 LLM)
- **Markdown**: react-markdown + rehype-raw + remark-gfm
- **Package**: electron-builder
- **WebSocket**: 실시간 백엔드 로그 동기화

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
flutter run -d web-server --web-port=3000
```

### 3. 데스크톱 앱 실행 (Tox&Feel)

```bash
# dation_clinic_app 디렉토리로 이동
cd dation_clinic_app

# 의존성 설치
npm install

# 개발 모드 실행
npm run dev
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

#### 3. Ollama 설치 (로컬 LLM)
```bash
# macOS
brew install ollama

# Linux
curl -fsSL https://ollama.ai/install.sh | sh

# Gemma2:2b 모델 다운로드 (백엔드용)
ollama pull gemma2:2b

# Gemma3:27b 모델 다운로드 (데스크톱 앱용)
ollama pull gemma3:27b
```

#### 4. 데이터베이스 설정
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

#### 5. 서버 실행
```bash
# WebSocket 지원을 위한 ASGI 서버 실행
daphne -b 0.0.0.0 -p 8000 config.asgi:application

# 또는 일반 Django 서버 (WebSocket 미지원)
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
flutter run -d web-server --web-port=3000

# 모바일 실행 (iOS)
flutter run -d ios

# 모바일 실행 (Android)
flutter run -d android
```

### Desktop App 설치 (dation_clinic_app - Tox&Feel)

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

#### RAG 검색 (하이브리드 검색)
```http
GET /api/v1/rags/retriever/{rag_id}?question={질문}
Authorization: Bearer {access_token}
```

#### 응답
```json
{
  "results": [
    {
      "content": "검색된 문서 내용",
      "score": 0.85,
      "metadata": {
        "source": "파일명.pdf",
        "page": 1
      }
    }
  ]
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
- **API Layer**: Google AI 및 RAG API 연동
- **Electron Main Process**: 데스크톱 앱 관리

## 🔍 주요 기능

### 1. RAG 시스템 (clinic_back + clinic_front)
- **문서 업로드**: PDF, DOCX 등 다양한 형식 지원
- **벡터 검색**: FAISS를 이용한 고속 유사도 검색
- **하이브리드 검색**: 키워드 매칭 + LLM 유사도 검색
- **한국어 형태소 분석**: KoNLPy를 이용한 조사 제거 및 어간 추출
- **Ollama 연동**: 로컬 Gemma2:2b 모델을 이용한 유사도 계산
- **질의응답**: 업로드된 문서 기반 AI 응답
- **문서 정보**: 문서 개수 및 크기 정보 표시
- **실시간 로그**: WebSocket을 통한 백엔드 로그 전송
- **API 제공**: RESTful API를 통한 외부 연동

### 2. Tox&Feel AI 병원 관리 시스템 (dation_clinic_app)
- **AI 챗봇**: Ollama Gemma3:27b 모델 기반 대화형 인터페이스 (톡스앤필 스태프 역할)
- **RAG API 설정**: 다중 RAG API 관리 및 설정
- **환자 관리**: EMR 데이터 관리
- **예약 시스템**: 환자 예약 관리
- **수술 기록**: 수술 관련 데이터 관리
- **CRM 시스템**: 고객 관계 관리
- **설문조사**: 환자 만족도 조사
- **실시간 로그**: WebSocket을 통한 백엔드 로그 동기화
- **Action Status**: API 호출 진행상황 실시간 모니터링
- **Assembling 애니메이션**: 응답 조립 과정 시각적 표시

### 3. 통합 기능
- **멀티 플랫폼**: 웹, 모바일, 데스크톱 지원
- **실시간 로그**: WebSocket을 통한 백엔드-프론트엔드 로그 동기화
- **세션 관리**: 대화 세션 저장/불러오기
- **데이터 동기화**: 클라우드 기반 데이터 관리
- **한국어 최적화**: 형태소 분석을 통한 정확한 키워드 매칭

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

#### 4. Ollama 연결 문제
```bash
# Ollama 서비스 상태 확인
ollama list

# 모델 재다운로드
ollama pull gemma3:27b

# 서비스 재시작
ollama serve
```

#### 5. 포트 충돌
```bash
# 사용 중인 포트 확인
lsof -i :8000  # 백엔드
lsof -i :3000  # 프론트엔드
lsof -i :5173  # Electron 앱
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

#### Electron 앱 로그
```bash
# 개발자 도구 열기
# Ctrl+Shift+I (Windows/Linux) 또는 Cmd+Option+I (macOS)
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

## 🔄 최근 업데이트

### v2.1.0 (2024-8-7)
- **한국어 형태소 분석 추가**: KoNLPy를 이용한 조사 제거 및 어간 추출
- **WebSocket 실시간 로그 시스템**: Django Channels를 통한 백엔드-프론트엔드 로그 동기화
- **Action Status 개선**: API 호출 진행상황 실시간 모니터링
- **Assembling 애니메이션**: 응답 조립 과정 시각적 표시
- **로그 최적화**: 유사도 평가 로그 간소화 및 사용자 경험 개선
- **한국어 키워드 매칭 개선**: "하이코란"과 "하이코가 뭐야"에서 "하이코" 공통 키워드 인식

### v2.0.0 (2024-8-7)
- **제조용 BOM/SOP 로직 완전 제거**: 모든 관련 컨텐츠와 로직 삭제
- **앱명 변경**: "Dation MK Agent" → "Tox&Feel"
- **AI 엔진 변경**: Google Gemini → Ollama Gemma3:27b (로컬 LLM)
- **톡스앤필 스태프 역할 설정**: 친절하고 전문적인 피부과 스태프로서의 응답 스타일 구현
- **RAG API 기능 대폭 개선**:
  - 하이브리드 검색 (키워드 + LLM 유사도) 구현
  - Ollama Gemma2:2b 모델 연동 (백엔드)
  - 병렬 처리 및 성능 최적화
  - 타임아웃 설정 (1시간)
- **RAG API 설정 페이지 추가**: 다중 RAG API 관리 기능
- **Flutter 프론트엔드 개선**: 문서 개수 및 크기 정보 표시
- **문법 오류 수정**: InteractionPage.jsx 중괄호 문제 해결

## 📄 라이선스

이 프로젝트의 상업적인 이용에 대해서는 **tony@banya.ai**로 문의해 주세요.

---

**Tox&Feel** - AI 기반 의료 업무 자동화와 의사결정 지원을 위한 종합적인 의료 관리 시스템 