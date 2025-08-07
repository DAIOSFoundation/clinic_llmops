import numpy as np
import requests
import json
from typing import List, Dict, Tuple
import logging
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
import threading

logger = logging.getLogger(__name__)


def get_llm_similarity_score(query: str, document_text: str, model_name: str = "gemma2:2b") -> float:
    """
    Ollama Gemma2 2B 모델을 사용하여 쿼리와 문서 간의 문맥적 유사도를 직접 평가합니다.
    """
    try:
        start_time = time.time()
        # 상세 로그 제거 - WebSocket으로 전송되는 로그가 너무 많아지는 것을 방지
        # logger.info(f"LLM 유사도 평가 시작 - 쿼리: {query[:50]}...")
        
        # Ollama API 엔드포인트
        url = "http://localhost:11434/api/generate"
        
        # 유사도 평가를 위한 프롬프트
        prompt = f"""다음은 사용자의 질문과 문서 내용입니다. 이 둘의 문맥적 유사도를 0.0부터 1.0까지의 점수로 평가해주세요.

질문: {query}

문서 내용: {document_text[:2000]}  # 문서가 너무 길면 잘라냄

평가 기준:
- 0.0-0.2: 전혀 관련 없음
- 0.2-0.4: 약간 관련 있음
- 0.4-0.6: 중간 정도 관련 있음
- 0.6-0.8: 상당히 관련 있음
- 0.8-1.0: 매우 관련 있음

점수만 숫자로 응답해주세요 (예: 0.75):"""
        
        # 요청 데이터
        data = {
            "model": model_name,
            "prompt": prompt,
            "stream": False,
            "options": {
                "temperature": 0.1,  # 일관된 평가를 위해 낮은 온도
                "top_p": 0.9
            }
        }
        
        # API 호출
        # logger.info(f"Ollama API 호출 시작...")
        response = requests.post(url, json=data, timeout=60)
        response.raise_for_status()
        # logger.info(f"Ollama API 호출 완료")
        
        # 응답에서 점수 추출
        result = response.json()
        response_text = result.get("response", "").strip()
        # logger.info(f"Ollama 응답: {response_text[:100]}...")
        
                # 숫자만 추출
        try:
            # 다양한 형식의 숫자 응답 처리
            import re
            number_match = re.search(r'0\.\d+', response_text)
            if number_match:
                score = float(number_match.group())
                # 점수 범위 제한 (0.0-1.0)
                score = max(0.0, min(1.0, score))
                
                end_time = time.time()
                elapsed_time = end_time - start_time
                # logger.info(f"LLM 유사도 평가 완료 - 점수: {score}, 소요시간: {elapsed_time:.2f}초")
                
                return score
            else:
                logger.warning(f"LLM 응답에서 숫자를 찾을 수 없음: {response_text}")
                return 0.0
                
        except (ValueError, TypeError) as e:
            logger.error(f"점수 파싱 오류: {e}, 응답: {response_text}")
            return 0.0
        
    except requests.exceptions.RequestException as e:
        logger.error(f"Ollama API 호출 실패: {e}")
        raise RuntimeError(f"Ollama API 호출 실패: {e}")
    except Exception as e:
        logger.error(f"유사도 평가 중 오류: {e}")
        raise RuntimeError(f"유사도 평가 중 오류: {e}")


def serialize_similarity_results(results: List[Tuple[float, any]]) -> List[Dict]:
    """
    유사도 검색 결과를 직렬화된 딕셔너리 리스트로 변환합니다.
    """
    serialized_docs = []
    for score, doc in results:
        page_content = ""
        metadata = {}

        # doc이 딕셔너리인 경우 (예: FAISS에서 직접 반환되는 경우)
        if isinstance(doc, dict):
            page_content = doc.get("page_content", "")
            metadata = doc.get("metadata", {})
        # doc이 Langchain Document 객체인 경우
        else:
            if hasattr(doc, "page_content"):
                pc = getattr(doc, "page_content")
                page_content = pc if isinstance(pc, (str, dict)) else repr(pc)
            if hasattr(doc, "metadata"):
                metadata = getattr(doc, "metadata")
                metadata = metadata if isinstance(metadata, dict) else {}

        serialized_docs.append(
            {
                "page_content": page_content,
                "metadata": metadata,
                "score": float(score),
            }
        )
    return serialized_docs


def keyword_filter_documents(query: str, docs: List, max_candidates: int = 50) -> List:
    """
    키워드 기반 1차 필터링을 수행합니다.
    """
    try:
        logger.info(f"키워드 필터링 시작 - 쿼리: {query}")
        
        # 쿼리에서 키워드 추출 (더 정교한 토큰화)
        import re
        
        # 특수문자 제거 및 토큰화
        clean_query = re.sub(r'[^\w\s]', '', query.lower())
        query_keywords = set(clean_query.split())
        
        # 의미있는 키워드만 필터링 (1글자 단어 제외)
        query_keywords = {kw for kw in query_keywords if len(kw) > 1}
        
        logger.info(f"추출된 쿼리 키워드: {query_keywords}")
        
        # 문서별 키워드 매칭 점수 계산
        doc_scores = []
        
        for i, doc in enumerate(docs):
            # 문서 텍스트 추출
            if hasattr(doc, "page_content"):
                doc_text = doc.page_content
            elif isinstance(doc, dict) and "page_content" in doc:
                doc_text = doc["page_content"]
            else:
                doc_text = str(doc)
            
            # 문서 텍스트를 소문자로 변환하고 키워드 추출
            clean_doc_text = re.sub(r'[^\w\s]', '', doc_text.lower())
            doc_keywords = set(clean_doc_text.split())
            
            # 의미있는 키워드만 필터링 (1글자 단어 제외)
            doc_keywords = {kw for kw in doc_keywords if len(kw) > 1}
            
            # 키워드 매칭 점수 계산
            intersection = len(query_keywords.intersection(doc_keywords))
            union = len(query_keywords.union(doc_keywords))
            
            if union > 0:
                jaccard_score = intersection / union
            else:
                jaccard_score = 0.0
            
            # 키워드 포함 개수 및 비율
            keyword_count = intersection
            keyword_ratio = keyword_count / len(query_keywords) if query_keywords else 0.0
            
            # 종합 점수 (키워드 매칭 + 포함 개수)
            total_score = jaccard_score * 0.6 + keyword_ratio * 0.4
            
            # 키워드가 하나도 매칭되지 않으면 매우 낮은 점수
            if keyword_count == 0:
                total_score = 0.01
            
            # 상위 5개 문서의 점수만 로깅 (성능 고려) - WebSocket 로그 제한
            # if len(doc_scores) < 5:
            #     logger.info(f"문서 {i+1} 키워드 점수: Jaccard={jaccard_score:.3f}, 키워드수={keyword_count}, 총점={total_score:.3f}")
            
            doc_scores.append((total_score, i, doc))
        
        # 점수 순으로 정렬
        doc_scores.sort(key=lambda x: x[0], reverse=True)
        
        # 상위 문서들 선택
        filtered_docs = [doc for score, i, doc in doc_scores[:max_candidates]]
        
        logger.info(f"키워드 필터링 완료: {len(docs)}개 → {len(filtered_docs)}개")
        
        return filtered_docs
        
    except Exception as e:
        logger.error(f"키워드 필터링 중 오류: {e}")
        # 오류 발생 시 원본 문서 반환
        return docs[:max_candidates]


def llm_similarity_search(query: str, docs: List, top_k: int = 5, model_name: str = "gemma2:2b") -> List[Tuple[float, any]]:
    """
    키워드 기반 1차 필터링 + LLM 유사도 2차 검색을 수행합니다.
    """
    try:
        start_time = time.time()
        logger.info(f"하이브리드 검색 시작 - 문서 개수: {len(docs)}개")
        
        # 1단계: 키워드 기반 1차 필터링
        filtered_docs = keyword_filter_documents(query, docs, max_candidates=30)
        
        # 2단계: 필터링된 문서에 대해 LLM 유사도 평가
        results = []
        results_lock = threading.Lock()
        
        def process_document(doc_index, doc):
            """개별 문서를 처리하는 함수"""
            try:
                # 페이지 콘텐츠 텍스트 추출
                if hasattr(doc, "page_content"):
                    original_text = doc.page_content
                elif isinstance(doc, dict) and "page_content" in doc:
                    original_text = doc["page_content"]
                else:
                    original_text = str(doc)  # Fallback for unexpected doc types

                # 줄바꿈 제거 및 전처리
                clean_text = original_text.replace("\n", " ").strip()
                
                # 텍스트가 너무 길면 잘라내기 (LLM 처리 제한 고려)
                if len(clean_text) > 2000:
                    clean_text = clean_text[:2000]

                # logger.info(f"문서 {doc_index+1}/{len(filtered_docs)} LLM 처리 중...")
                # LLM을 사용한 유사도 점수 계산
                score = get_llm_similarity_score(query, clean_text, model_name)
                
                # 스레드 안전하게 결과 저장
                with results_lock:
                    results.append((score, doc))
                    
                # logger.info(f"문서 {doc_index+1} 완료 - 점수: {score}")
                return True
                
            except Exception as e:
                logger.error(f"문서 {doc_index+1} 처리 실패: {e}")
                return False
        
        # 병렬 처리 실행
        max_workers = min(5, len(filtered_docs))  # 필터링된 문서가 적으므로 스레드 수 줄임
        logger.info(f"LLM 병렬 처리 시작 - 스레드 수: {max_workers}")
        
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # 필터링된 문서에 대해 병렬 처리 시작
            future_to_doc = {
                executor.submit(process_document, i, doc): (i, doc) 
                for i, doc in enumerate(filtered_docs)
            }
            
            # 완료된 작업들을 기다리며 진행상황 로깅
            completed_count = 0
            for future in as_completed(future_to_doc):
                doc_index, doc = future_to_doc[future]
                completed_count += 1
                
                try:
                    success = future.result()
                    if success:
                        # 진행률 로그는 10% 단위로만 표시
                        if completed_count % max(1, len(filtered_docs) // 10) == 0 or completed_count == len(filtered_docs):
                            logger.info(f"LLM 진행률: {completed_count}/{len(filtered_docs)} ({completed_count/len(filtered_docs)*100:.1f}%)")
                except Exception as e:
                    logger.error(f"문서 {doc_index+1} 처리 중 예외 발생: {e}")

        # 유사도가 높은 순으로 정렬
        results.sort(key=lambda x: x[0], reverse=True)
        final_results = results[:top_k]
        
        end_time = time.time()
        total_time = end_time - start_time
        logger.info(f"하이브리드 검색 완료 - 소요시간: {total_time:.2f}초, 결과 개수: {len(final_results)}개")
        
        return final_results
        
    except Exception as e:
        logger.error(f"LLM 유사도 검색 중 오류: {e}")
        raise RuntimeError(f"LLM 유사도 검색 중 오류: {e}")


def check_ollama_availability(model_name: str = "gemma2:2b") -> bool:
    """
    Ollama 서비스와 모델의 가용성을 확인합니다.
    """
    try:
        # Ollama 서비스 상태 확인
        response = requests.get("http://localhost:11434/api/tags", timeout=5)
        if response.status_code != 200:
            return False
        
        # 사용 가능한 모델 목록 확인
        models = response.json().get("models", [])
        available_models = [model["name"] for model in models]
        
        return model_name in available_models
        
    except Exception as e:
        logger.warning(f"Ollama 가용성 확인 실패: {e}")
        return False 