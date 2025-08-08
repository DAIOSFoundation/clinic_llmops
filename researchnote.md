# RAG 시스템 연구노트

## 개요
이 연구노트는 클리닉 LLMOps 프로젝트의 RAG(Retrieval-Augmented Generation) 시스템을 분석하여 각 구성 요소의 구현 방법과 사용된 기술을 정리한 문서입니다.

## 시스템 아키텍처 도식화

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           RAG 시스템 전체 아키텍처                           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────┐  │
│  │   문서 벡터화   │    │   벡터 검색     │    │   의도 분석 LLM        │  │
│  │   (Vectorization)│    │   (Retrieval)   │    │   (Intent Analysis)    │  │
│  └─────────────────┘    └─────────────────┘    └─────────────────────────┘  │
│           │                       │                       │                  │
│           ▼                       ▼                       ▼                  │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────┐  │
│  │  문서 청킹      │    │  하이브리드 검색 │    │  엔티티 추출           │  │
│  │  (Chunking)     │    │  (Hybrid Search)│    │  (Entity Extraction)   │  │
│  └─────────────────┘    └─────────────────┘    └─────────────────────────┘  │
│           │                       │                       │                  │
│           ▼                       ▼                       ▼                  │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────┐  │
│  │  임베딩 생성    │    │  성능 최적화    │    │  최종 응답 조립        │  │
│  │  (Embedding)    │    │  (Optimization) │    │  (Response Assembly)   │  │
│  └─────────────────┘    └─────────────────┘    └─────────────────────────┘  │
│           │                       │                       │                  │
│           ▼                       ▼                       ▼                  │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────┐  │
│  │  FAISS 저장     │    │  병렬 처리      │    │  컨텍스트 조합         │  │
│  │  (FAISS Store)  │    │  (Parallel)     │    │  (Context Combination) │  │
│  └─────────────────┘    └─────────────────┘    └─────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## 1. 문서 벡터화 (Document Vectorization)

### 1.1 구현 방법

#### 문서 로딩 및 전처리
- **파일 형식 지원**: PDF, TXT, JSON, CSV
- **로더 구현**: LangChain의 다양한 DocumentLoader 활용
  - `PyPDFLoader`: PDF 문서 처리
  - `TextLoader`: 텍스트 파일 처리
  - `JSONLoader`: JSON 파일 처리 (jq 스키마 기반)
  - `CSVLoader`: CSV 파일 처리 (다중 인코딩 지원)

#### 문서 청킹 (Chunking)
```python
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=2000,        # 청크 크기
    chunk_overlap=300,      # 청크 간 겹침
    length_function=len,    # 길이 측정 함수
    is_separator_regex=False
)
```

#### 임베딩 생성
- **모델**: `sentence-transformers/paraphrase-multilingual-mpnet-base-v2`
- **특징**: 다국어 지원, 한국어 최적화
- **차원**: 768차원 벡터

### 1.2 사용된 기술
- **LangChain**: 문서 처리 파이프라인
- **Sentence Transformers**: 다국어 임베딩 모델
- **FAISS**: 벡터 저장 및 인덱싱
- **RecursiveCharacterTextSplitter**: 지능형 텍스트 분할

## 2. 벡터화된 문서 검색 (Vector Search)

### 2.1 구현 방법

#### FAISS 벡터스토어 관리
```python
def create_or_update_faiss_vector_store(chunks: List[Document], vector_store_id: str):
    embeddings = get_huggingface_embeddings_model()
    path = os.path.join(settings.RAG_FAISS_INDEX_PATH, str(vector_store_id))
    
    if os.path.exists(path):
        vectorstore = FAISS.load_local(path, embeddings)
        vectorstore.add_documents(chunks)
    else:
        vectorstore = FAISS.from_documents(chunks, embeddings)
    
    vectorstore.save_local(path)
```

#### 하이브리드 검색 시스템
1. **1차 필터링**: 한국어 형태소 분석 기반 키워드 매칭
2. **2차 검색**: LLM 기반 문맥적 유사도 평가

### 2.2 사용된 기술
- **FAISS**: 고속 벡터 유사도 검색
- **KoNLPy (Okt)**: 한국어 형태소 분석
- **ThreadPoolExecutor**: 병렬 처리
- **Jaccard 유사도**: 키워드 기반 유사도 계산

## 3. 의도 분석 LLM (Intent Analysis LLM)

### 3.1 구현 방법

#### 한국어 형태소 분석
```python
def extract_korean_keywords(text: str) -> Set[str]:
    morphs = okt.pos(clean_text, norm=True, stem=True)
    keywords = set()
    
    for word, pos in morphs:
        if pos in ['Noun', 'Adjective', 'Verb'] and len(word) > 1:
            keywords.add(word)
    
    return keywords
```

#### 키워드 기반 1차 필터링
```python
def keyword_filter_documents(query: str, docs: List, max_candidates: int = 50):
    query_keywords = extract_korean_keywords(query)
    
    for doc in docs:
        doc_keywords = extract_korean_keywords(doc.page_content)
        total_score = get_korean_similarity_score(query_keywords, doc_keywords)
        # 점수 계산 및 정렬
```

#### LLM 유사도 평가
```python
def get_llm_similarity_score(query: str, document_text: str, model_name: str = "gemma2:2b"):
    prompt = f"""다음은 사용자의 질문과 문서 내용입니다. 이 둘의 문맥적 유사도를 0.0부터 1.0까지의 점수로 평가해주세요.
    
    질문: {query}
    문서 내용: {document_text[:2000]}
    
    평가 기준:
    - 0.0-0.2: 전혀 관련 없음
    - 0.2-0.4: 약간 관련 있음
    - 0.4-0.6: 중간 정도 관련 있음
    - 0.6-0.8: 상당히 관련 있음
    - 0.8-1.0: 매우 관련 있음
    
    점수만 숫자로 응답해주세요 (예: 0.75):"""
```

### 3.2 사용된 기술
- **Ollama Gemma2:2b**: 로컬 LLM 모델
- **KoNLPy Okt**: 한국어 형태소 분석기
- **Jaccard 유사도**: 키워드 매칭 점수
- **Threading**: 병렬 LLM 호출

## 4. 검색 효율과 성능 향상 (Search Efficiency & Performance)

### 4.1 구현 방법

#### 병렬 처리 최적화
```python
def llm_similarity_search(query: str, docs: List, top_k: int = 5):
    # 1단계: 키워드 기반 1차 필터링
    filtered_docs = keyword_filter_documents(query, docs, max_candidates=30)
    
    # 2단계: 필터링된 문서에 대해 LLM 유사도 평가 (병렬 처리)
    max_workers = min(5, len(filtered_docs))
    
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        future_to_doc = {
            executor.submit(process_document, i, doc): (i, doc) 
            for i, doc in enumerate(filtered_docs)
        }
```

#### 메모리 최적화
- **텍스트 길이 제한**: 2000자로 제한하여 LLM 처리 효율성 향상
- **청크 크기 최적화**: 2000자 청크, 300자 오버랩
- **캐싱**: 임베딩 모델 싱글톤 패턴

#### 한국어 특화 최적화
```python
def get_korean_similarity_score(query_keywords: Set[str], doc_keywords: Set[str]) -> float:
    intersection = len(query_keywords.intersection(doc_keywords))
    union = len(query_keywords.union(doc_keywords))
    
    jaccard_score = intersection / union
    keyword_ratio = intersection / len(query_keywords) if query_keywords else 0.0
    
    # 종합 점수 (Jaccard 60% + 키워드 비율 40%)
    total_score = jaccard_score * 0.6 + keyword_ratio * 0.4
    return total_score
```

### 4.2 사용된 기술
- **ThreadPoolExecutor**: 병렬 처리
- **Threading Lock**: 스레드 안전성
- **메모리 관리**: 텍스트 길이 제한
- **캐싱 전략**: 모델 재사용

## 5. 최종 LLM 응답 조립 (Final Response Assembly)

### 5.1 구현 방법

#### 컨텍스트 조합
```javascript
// 컨텍스트 최적화: 각 문서의 내용을 요약하고 길이 제한
const optimizedDocs = ragData.data.documents.map(doc => {
    let content = doc.page_content;
    
    // 문서 내용이 너무 길면 잘라내기 (각 문서당 최대 500자)
    if (content.length > 500) {
        content = content.substring(0, 500) + '...';
    }
    
    // 줄바꿈을 공백으로 변환하여 가독성 개선
    content = content.replace(/\n+/g, ' ').trim();
    
    return content;
});

// 상위 3개 문서만 사용 (유사도가 높은 문서들)
const topDocs = optimizedDocs.slice(0, 3);
ragContext = topDocs.join('\n\n---\n\n');
```

#### 프롬프트 엔지니어링
```javascript
const systemPrompt = `당신은 톡스앤필(Tox&Feel) 피부과의 친절하고 전문적인 스태프입니다.

주요 역할과 응답 스타일:
- 환자와의 상호작용에서 항상 따뜻하고 이해심 있는 태도로 응답
- 의료 전문가로서의 전문성을 바탕으로 정확하고 도움이 되는 정보 제공
- 의료 용어를 쉽게 설명하여 환자가 이해할 수 있도록 도움
- 환자의 안녕을 진심으로 걱정하는 마음으로 응답
- 정확한 의료 정보 제공과 함께 환자의 편안함을 고려
- 친근하면서도 전문적인 톤으로 응답
- 환자의 질문에 대해 구체적이고 실용적인 조언 제공`;

let finalPrompt = promptText;
if (context && context.trim() !== '') {
    finalPrompt = `[참고 정보]:\n${context}\n\n[환자 질문]:\n${promptText}`;
}
```

#### 응답 생성
```javascript
const response = await fetch(`${OLLAMA_BASE_URL}/api/generate`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json',
    },
    body: JSON.stringify({
        model: 'gemma3:27b',
        system: systemPrompt,
        prompt: finalPrompt,
        stream: false,
        options: {
            temperature: 0.7,
            top_p: 0.9,
            max_tokens: 2000
        }
    })
});
```

### 5.2 사용된 기술
- **Ollama Gemma3:27b**: 최종 응답 생성
- **프롬프트 엔지니어링**: 시스템 프롬프트 최적화
- **컨텍스트 윈도우**: 관련 문서 정보 조합
- **응답 후처리**: 마크다운 렌더링

## 6. 성능 분석 및 최적화 결과

### 6.1 검색 성능
- **1차 필터링**: 키워드 매칭으로 후보 문서 수를 30개로 제한
- **2차 검색**: LLM 유사도 평가로 정확도 향상
- **병렬 처리**: 5개 스레드로 동시 처리하여 속도 향상

### 6.2 정확도 개선
- **한국어 특화**: 형태소 분석으로 조사 제거 및 어간 추출
- **하이브리드 접근**: 키워드 + 문맥적 유사도 조합
- **임계값 설정**: 0.8 이상의 유사도만 최종 결과로 선별

### 6.3 메모리 효율성
- **텍스트 길이 제한**: 2000자로 LLM 입력 제한
- **청크 최적화**: 2000자 청크, 300자 오버랩
- **캐싱**: 임베딩 모델 재사용

## 7. 기술 스택 요약

### 7.1 백엔드 (Django)
- **벡터 저장소**: FAISS
- **임베딩 모델**: Sentence Transformers (paraphrase-multilingual-mpnet-base-v2)
- **한국어 처리**: KoNLPy (Okt)
- **문서 처리**: LangChain
- **LLM**: Ollama (Gemma2:2b, Gemma3:27b)

### 7.2 프론트엔드 (React/Flutter)
- **상태 관리**: React Hooks / BLoC
- **API 통신**: Fetch API / Dio
- **UI 렌더링**: React / Flutter Widgets
- **마크다운**: ReactMarkdown

### 7.3 데스크톱 앱 (Electron)
- **프레임워크**: Electron + React
- **LLM 통신**: Ollama API
- **파일 처리**: Node.js fs 모듈

## 8. 향후 개선 방향

### 8.1 성능 최적화
- **벡터 압축**: PQ (Product Quantization) 적용
- **캐싱 레이어**: Redis 도입
- **비동기 처리**: Celery 작업 큐 도입

### 8.2 정확도 향상
- **다중 임베딩**: 다양한 모델 앙상블
- **재순위화**: Cross-Encoder 모델 적용
- **피드백 루프**: 사용자 피드백 기반 학습

### 8.3 확장성 개선
- **마이크로서비스**: 각 컴포넌트 분리
- **로드 밸런싱**: 다중 인스턴스 지원
- **모니터링**: Prometheus + Grafana 도입

---

*이 연구노트는 클리닉 LLMOps 프로젝트의 RAG 시스템 구현을 분석한 결과입니다. 각 부분의 구현 세부사항과 기술적 선택의 근거를 포함하고 있습니다.*
