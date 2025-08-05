from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from core.constants.error_code import (
    RAG_NOT_FOUND,
    SUCCESS_OK,
)
from apps.rag.services import RagService
from apps.rag.serializers import (
    RagCreateSerializer,
    RagSerializer,
    RagFilesSerializer,
    RagPatchSerializer,
)
from core.exceptions.app_exception import AppException
from core.utils.jwt import verify_token

import logging


logger = logging.getLogger(__name__)


class RagAPIView(APIView):
    def post(self, request):
        payload = getattr(request, "user_payload", None)
        if payload is None:
            return Response(
                {"error": "Authorization header with a valid token is required"},
                status=status.HTTP_401_UNAUTHORIZED,
            )

        try:
            serializer = RagCreateSerializer(data=request.data)
            serializer.is_valid(raise_exception=True)

            name = serializer.validated_data["name"]
            description = serializer.validated_data.get("description", "")
            rag_file_ids = serializer.validated_data["rag_file_ids"]

            rag = RagService.create(
                user_id=payload["sub"],
                name=name,
                description=description,
                rag_file_ids=rag_file_ids,
            )
            response_serializer = RagSerializer(rag)

            return Response(response_serializer.data, status=status.HTTP_201_CREATED)
        except AppException:
            raise
        except Exception as e:
            logger.exception(f"rag create failed: {str(e)}")
            raise AppException(
                f"rag create failed: {str(e)}",
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

    def get(self, request, id=None):
        try:
            payload = getattr(request, "user_payload", None)

            if payload is None:
                return Response(
                    {"error": "Authorization header with a valid token is required"},
                    status=status.HTTP_401_UNAUTHORIZED,
                )

            if id is not None:
                entity = RagService.get_by_id(id, payload["sub"])
                if not entity:
                    raise AppException(
                        code=RAG_NOT_FOUND, status_code=status.HTTP_404_NOT_FOUND
                    )

                serializer = RagFilesSerializer(entity)
                return Response(serializer.data, status=status.HTTP_200_OK)
            else:
                entities = RagService.get_all(payload["sub"])
                serializer = RagSerializer(entities, many=True)
                return Response(serializer.data, status=status.HTTP_200_OK)
        except AppException:
            raise
        except Exception as e:
            logger.exception(f"rag get failed: {str(e)}")
            raise AppException(
                f"rag detail failed: {str(e)}",
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

    def patch(self, request, id):
        payload = getattr(request, "user_payload", None)

        if payload is None:
            return Response(
                {"error": "Authorization header with a valid token is required"},
                status=status.HTTP_401_UNAUTHORIZED,
            )

        try:
            serializer = RagPatchSerializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            name = serializer.validated_data["name"]
            description = serializer.validated_data.get("description", "")
            rag_file_ids = serializer.validated_data["rag_file_ids"]

            updated_rag = RagService.update(
                id=id,
                user_id=payload["sub"],
                name=name,
                description=description,
                rag_file_ids=rag_file_ids,
            )

            if not updated_rag:
                raise AppException(code=RAG_NOT_FOUND, status_code=404)

            response_serializer = RagSerializer(updated_rag)
            return Response(response_serializer.data, status=status.HTTP_200_OK)

        except AppException:
            raise
        except Exception as e:
            logger.exception(f"rag patch failed: {str(e)}")
            raise AppException(
                f"rag detail failed: {str(e)}",
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

    def delete(self, request, id):
        payload = getattr(request, "user_payload", None)

        if payload is None:
            return Response(
                {"error": "Authorization header with a valid token is required"},
                status=status.HTTP_401_UNAUTHORIZED,
            )
        try:
            deleted = RagService.delete(id=id, user_id=payload["sub"])

            if not deleted:
                raise AppException(
                    code=RAG_NOT_FOUND, status_code=status.HTTP_404_NOT_FOUND
                )

            return Response(SUCCESS_OK, status=status.HTTP_200_OK)

        except AppException:
            raise
        except Exception as e:
            logger.exception(f"rag delete failed: {str(e)}")
            raise AppException(
                f"rag detail failed: {str(e)}",
                stauts_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
