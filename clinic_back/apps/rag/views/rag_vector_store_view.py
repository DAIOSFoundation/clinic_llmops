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
            logger.info(f"=== RAG API 호출 시작 ===")
            
            # 여러 방법으로 question 파라미터 추출 시도
            question = None
            
            # 1. query_params에서 추출
            question = request.query_params.get("question")
            logger.info(f"1. query_params에서 추출: {question}")
            
            # 2. GET 파라미터에서 직접 추출
            if not question:
                question = request.GET.get("question")
                logger.info(f"2. GET 파라미터에서 추출: {question}")
            
            # 3. URL 디코딩 처리
            if question:
                try:
                    question = unquote(question)
                    logger.info(f"3. URL 디코딩 후: {question}")
                except Exception as e:
                    logger.warning(f"URL 디코딩 실패: {e}")
            
            # 4. 로깅
            logger.info(f"최종 question: {question}")
            logger.info(f"RAG ID: {name}")
            
            if not question:
                raise AppException(
                    code=RAG_NEED_QUESTION, status_code=status.HTTP_400_BAD_REQUEST
                )

            path = os.path.join(settings.RAG_FAISS_INDEX_PATH, name)
            logger.info(f"FAISS 경로: {path}")

            logger.info(f"임베딩 모델 로딩 시작...")
            embeddings = get_huggingface_embeddings_model()
            logger.info(f"임베딩 모델 로딩 완료")

            logger.info(f"FAISS 벡터스토어 로딩 시작...")
            vectorstore = FAISS.load_local(
                path, embeddings=embeddings, allow_dangerous_deserialization=True
            )
            logger.info(f"FAISS 벡터스토어 로딩 완료")

            all_docs = list(vectorstore.docstore._dict.values())
            logger.info(f"문서 개수: {len(all_docs)}개")

            # Ollama 가용성 확인
            logger.info(f"Ollama 가용성 확인 시작...")
            if not check_ollama_availability():
                raise AppException(
                    "Ollama 서비스가 실행되지 않거나 gemma2:2b 모델이 설치되지 않았습니다.",
                    status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                )
            logger.info(f"Ollama 가용성 확인 완료")

            logger.info(f"LLM 유사도 검색 시작...")
            results = llm_similarity_search(query=question, docs=all_docs, top_k=3)
            logger.info(f"LLM 유사도 검색 완료")

            logger.info(f"결과 직렬화 시작...")
            documents = serialize_similarity_results(results)
            logger.info(f"결과 직렬화 완료")

            # db_path = name
            # vectorstore = RagVectorStoreService.load(db_path)
            # retriever = RagVectorStoreService.get_retriever(db_path=db_path)
            # documents = retriever.get_relevant_documents(question)
            logger.info(f"응답 직렬화 시작...")
            serializer = RagRetrieverResponseSerializer({"documents": documents})
            logger.info(f"응답 직렬화 완료")
            
            end_time = time.time()
            total_time = end_time - start_time
            logger.info(f"=== RAG API 호출 완료 (총 소요시간: {total_time:.2f}초) ===")
            
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            logger.error(f"RAG API 오류: {str(e)}", exc_info=True)
            raise AppException(
                f"retriever failed: {str(e)}",
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
