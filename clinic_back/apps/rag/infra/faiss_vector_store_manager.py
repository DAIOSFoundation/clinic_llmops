import os
import shutil
from django.conf import settings
from langchain_community.vectorstores import FAISS
from langchain_core.documents import Document
from typing import List
from core.utils.model_loader import (
    get_huggingface_embeddings_model,
)


def create_or_update_faiss_vector_store(chunks: List[Document], vector_store_id: str):
    """
    주어진 청크로 FAISS 벡터 스토어를 생성하거나 기존 스토어를 업데이트합니다.
    """
    embeddings = get_huggingface_embeddings_model()
    if embeddings is None:
        raise RuntimeError("임베딩 모델이 로드되지 않았습니다.")

    path = os.path.join(settings.RAG_FAISS_INDEX_PATH, str(vector_store_id))

    if os.path.exists(path):
        vectorstore = FAISS.load_local(
            path, embeddings, allow_dangerous_deserialization=True
        )
        vectorstore.add_documents(chunks)
    else:
        vectorstore = FAISS.from_documents(chunks, embeddings)

    vectorstore.save_local(path)
    return vectorstore


def load_faiss_vector_store(vector_store_id: str):
    """
    지정된 ID의 FAISS 벡터 스토어를 로드합니다.
    """
    path = os.path.join(settings.RAG_FAISS_INDEX_PATH, vector_store_id)
    if not os.path.exists(path):
        raise FileNotFoundError(
            f"FAISS 벡터 스토어 '{vector_store_id}'를 찾을 수 없습니다: {path}"
        )

    embeddings = get_huggingface_embeddings_model()
    if embeddings is None:
        raise RuntimeError(
            "임베딩 모델이 로드되지 않았습니다. model_loader를 확인하세요."
        )

    vectorstore = FAISS.load_local(
        path, embeddings, allow_dangerous_deserialization=True
    )
    return vectorstore


def get_faiss_retriever(vector_store_id: str):
    """
    지정된 ID의 FAISS 벡터 스토어로부터 LangChain Retriever 객체를 반환합니다.
    """
    vectorstore = load_faiss_vector_store(vector_store_id)
    retriever = vectorstore.as_retriever()
    return retriever


def delete_faiss_vector_store(vector_store_id: str):
    """
    지정된 ID의 FAISS 벡터 스토어를 삭제합니다.
    """
    path = os.path.join(settings.RAG_FAISS_INDEX_PATH, str(vector_store_id))
    if os.path.exists(path):
        shutil.rmtree(path)
    else:
        print(
            f"Warning: Vector store '{vector_store_id}' not found at {path} for deletion."
        )


def get_vector_store_info(vector_store_id: str):
    """
    지정된 ID의 FAISS 벡터 스토어 정보를 반환합니다.
    """
    try:
        path = os.path.join(settings.RAG_FAISS_INDEX_PATH, str(vector_store_id))
        if not os.path.exists(path):
            return {
                "document_count": 0,
                "total_size_bytes": 0,
                "total_size_mb": 0,
                "exists": False
            }

        embeddings = get_huggingface_embeddings_model()
        if embeddings is None:
            return {
                "document_count": 0,
                "total_size_bytes": 0,
                "total_size_mb": 0,
                "exists": False
            }

        vectorstore = FAISS.load_local(
            path, embeddings, allow_dangerous_deserialization=True
        )
        
        # 문서 개수
        document_count = len(vectorstore.docstore._dict)
        
        # 전체 텍스트 크기 계산
        total_size_bytes = 0
        for doc in vectorstore.docstore._dict.values():
            if hasattr(doc, 'page_content'):
                total_size_bytes += len(doc.page_content.encode('utf-8'))
        
        total_size_mb = round(total_size_bytes / (1024 * 1024), 2)
        
        return {
            "document_count": document_count,
            "total_size_bytes": total_size_bytes,
            "total_size_mb": total_size_mb,
            "exists": True
        }
    except Exception as e:
        print(f"Error getting vector store info: {e}")
        return {
            "document_count": 0,
            "total_size_bytes": 0,
            "total_size_mb": 0,
            "exists": False
        }
