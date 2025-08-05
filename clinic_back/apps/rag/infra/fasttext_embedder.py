import numpy as np
from core.utils.model_loader import get_fasttext_model


def get_text_embedding(text: str) -> np.ndarray:
    """
    주어진 텍스트에 대한 FastText 임베딩 벡터를 반환합니다.
    """
    fasttext_model = get_fasttext_model()
    if fasttext_model is None:
        raise RuntimeError(
            "FastText 모델이 로드되지 않았습니다. model_loader를 확인하세요."
        )
    return fasttext_model.get_sentence_vector(text)


def serialize_similarity_results(results: list) -> list[dict]:
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


def fasttext_similarity_search(query: str, docs: list, top_k: int = 5) -> list:
    """
    주어진 쿼리에 대해 문서 목록에서 FastText 기반 유사도 검색을 수행합니다.
    """
    query_vec = get_text_embedding(query)  # 클래스 없이 직접 함수 호출
    results = []

    for doc in docs:
        # 페이지 콘텐츠 텍스트 추출
        if hasattr(doc, "page_content"):
            original_text = doc.page_content
        elif isinstance(doc, dict) and "page_content" in doc:
            original_text = doc["page_content"]
        else:
            original_text = str(doc)  # Fallback for unexpected doc types

        # 줄바꿈 제거 및 전처리
        clean_text = original_text.replace("\n", " ").strip()

        # 문서 임베딩
        doc_vec = get_text_embedding(clean_text)  # 클래스 없이 직접 함수 호출

        # cosine similarity 계산
        # 0으로 나누는 오류 방지를 위해 작은 값 추가
        denominator = np.linalg.norm(query_vec) * np.linalg.norm(doc_vec)
        if denominator == 0:
            score = 0.0  # 또는 적절한 오류 처리
        else:
            score = np.dot(query_vec, doc_vec) / denominator

        results.append((score, doc))

    results.sort(key=lambda x: x[0], reverse=True)  # 유사도가 높은 순으로 정렬
    return results[:top_k]
