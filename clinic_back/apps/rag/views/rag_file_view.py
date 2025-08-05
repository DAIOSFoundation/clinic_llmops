from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser
from apps.rag.serializers import RagFileSerializer, RagFileUploadSerializer
from apps.rag.services import RagFileService
from core.exceptions.app_exception import AppException
import unicodedata
import logging


logger = logging.getLogger(__name__)


class RagFileAPIView(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request):
        ###TODO 수정
        fixed_user_id = "01f3ea2f-d13e-4bc8-9eb3-a8338a6a8ad7"

        try:
            serializer = RagFileUploadSerializer(data=request.data)
            serializer.is_valid(raise_exception=True)

            uploaded_file = serializer.validated_data["file"]
            uploaded_file.name = unicodedata.normalize("NFC", uploaded_file.name)

            rag_file_entity = RagFileService.upload(uploaded_file, fixed_user_id)

            response_serializer = RagFileSerializer(rag_file_entity)
            return Response(response_serializer.data, status=status.HTTP_201_CREATED)

        except Exception as e:
            logger.exception(f"file upload failed: {str(e)}")
            raise AppException(
                f"File upload failed: {str(e)}",
                code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )


# class RagEmbeddingAPIView(APIView):
#     parser_classes = (MultiPartParser, FormParser)
#
#     def post(self, request):
#         try:
#             serializer = RagEmbeddingSerializer(data=request.data)
#             serializer.is_valid(raise_exception=True)
#
#             uploaded_file = serializer.validated_data["file"]
#             name = serializer.validated_data.get("name")
#
#             rag_file_entity = RagFileService.upload(uploaded_file)
#
#             temp_dir = "temp_uploads"
#             os.makedirs(temp_dir, exist_ok=True)
#             temp_file_path = os.path.join(temp_dir, uploaded_file.name)
#
#             ###TODO 메모리로
#             with open(temp_file_path, "wb+") as destination:
#                 for chunk in uploaded_file.chunks():
#                     destination.write(chunk)
#
#             chunks = RagFileService.load_and_split_document(
#                 temp_file_path, uploaded_file.name, rag_file_entity.url
#             )
#             for i, chunk in enumerate(chunks):
#                 if not isinstance(chunk.page_content, str):
#                     print(f"Chunk {i} page_content type: {type(chunk.page_content)}")
#             try:
#                 if chunks:
#                     RagVectorStoreService.create(chunks, name)
#                 else:
#                     destination.write(chunk)
#
#             except Exception as e:
#                 raise AppException(
#                     code=UNKNOWN_ERROR,
#                     status=status.HTTP_500_INTERNAL_SERVER_ERROR,
#                 )
#             finally:
#                 if os.path.exists(temp_file_path):
#                     os.remove(temp_file_path)
#                 response_serializer = RagFileSerializer(rag_file_entity)
#                 return Response(
#                     response_serializer.data, status=status.HTTP_201_CREATED
#                 )
#
#         except Exception as e:
#             print(e)
#             raise AppException(
#                 f"File upload failed: {str(e)}",
#                 code=status.HTTP_500_INTERNAL_SERVER_ERROR,
#             )
