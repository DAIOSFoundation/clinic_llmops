from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

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
from apps.rag.infra.fasttext_embedder import (
    serialize_similarity_results,
    fasttext_similarity_search,
)
import logging


logger = logging.getLogger(__name__)


class RagVectorStoreAPIView(APIView):
    def get(self, request, name: str):
        try:
            question = request.query_params.get("question")
            if not question:
                raise AppException(
                    code=RAG_NEED_QUESTION, status_code=status.HTTP_400_BAD_REQUEST
                )

            path = os.path.join(settings.RAG_FAISS_INDEX_PATH, name)

            embeddings = get_huggingface_embeddings_model()

            vectorstore = FAISS.load_local(
                path, embeddings=embeddings, allow_dangerous_deserialization=True
            )

            all_docs = list(vectorstore.docstore._dict.values())

            results = fasttext_similarity_search(query=question, docs=all_docs, top_k=5)

            documents = serialize_similarity_results(results)

            # db_path = name
            # vectorstore = RagVectorStoreService.load(db_path)
            # retriever = RagVectorStoreService.get_retriever(db_path=db_path)
            # documents = retriever.get_relevant_documents(question)
            serializer = RagRetrieverResponseSerializer({"documents": documents})
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Exception as e:
            raise AppException(
                f"retriever failed: {str(e)}",
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
