from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from urllib.parse import unquote
import time

from langchain_community.vectorstores import FAISS
from django.conf import settings
from core.constants.error_code import (
    RAG_NEED_QUESTION,
)
from apps.rag.serializers import (
    RagRetrieverResponseSerializer,
)
from core.exceptions.app_exception import AppException
import os

from core.utils.model_loader import (
    get_huggingface_embeddings_model,
)
from apps.rag.infra.ollama_embedder import (
    serialize_similarity_results,
    llm_similarity_search,
    check_ollama_availability,
)
import logging


logger = logging.getLogger(__name__)


class RagVectorStoreAPIView(APIView):
    def get(self, request, name: str):
        try:
            start_time = time.time()
            
            # 여러 방법으로 question 파라미터 추출 시도
            question = None
            
            # 1. query_params에서 추출
            question = request.query_params.get("question")
            
            # 2. GET 파라미터에서 직접 추출
            if not question:
                question = request.GET.get("question")
            
            # 3. URL 디코딩 처리
            if question:
                try:
                    question = unquote(question)
                except Exception as e:
                    logger.warning(f"URL 디코딩 실패: {e}")
            
            if not question:
                raise AppException(
                    code=RAG_NEED_QUESTION, status_code=status.HTTP_400_BAD_REQUEST
                )
            
            logger.info(f"🔍 유사도 검색 시작 - 질문: {question}")

            path = os.path.join(settings.RAG_FAISS_INDEX_PATH, name)

            # 임베딩 모델 로딩
            embeddings = get_huggingface_embeddings_model()

            # FAISS 벡터스토어 로딩
            vectorstore = FAISS.load_local(
                path, embeddings=embeddings, allow_dangerous_deserialization=True
            )

            all_docs = list(vectorstore.docstore._dict.values())

            # Ollama 가용성 확인
            if not check_ollama_availability():
                raise AppException(
                    "Ollama 서비스가 실행되지 않거나 gemma2:2b 모델이 설치되지 않았습니다.",
                    status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                )

            # LLM 유사도 검색
            results = llm_similarity_search(query=question, docs=all_docs, top_k=3)

            # 결과 직렬화
            documents = serialize_similarity_results(results)
            
            end_time = time.time()
            total_time = end_time - start_time
            logger.info(f"✅ 유사도 검색 완료 - 소요시간: {total_time:.2f}초")
            
            # 응답 직렬화
            serializer = RagRetrieverResponseSerializer({"documents": documents})
            
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            logger.error(f"RAG API 오류: {str(e)}", exc_info=True)
            raise AppException(
                f"retriever failed: {str(e)}",
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
