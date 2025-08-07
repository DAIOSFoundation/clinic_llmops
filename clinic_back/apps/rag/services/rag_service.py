from apps.rag.repositories import RagRepository, RagFileRepository
from apps.rag.entities import RagEntity
from django.core.exceptions import ObjectDoesNotExist
import uuid
from apps.rag.models import RagFile, Rag
from apps.rag.services.rag_file_service import RagFileService
from typing import Optional, List, Union
from apps.rag.infra.faiss_vector_store_manager import (
    create_or_update_faiss_vector_store,
    delete_faiss_vector_store,
)
from core.exceptions.app_exception import AppException

import uuid


class RagService:
    @staticmethod
    def get_all(user_id: uuid.UUID) -> Union[List[RagEntity], None]:
        try:
            rags = RagRepository.get_all(user_id)
        except ObjectDoesNotExist:
            return None
        return rags

    @staticmethod
    def create(
        user_id: uuid.UUID, name: str, description: str, rag_file_ids: List[uuid.UUID]
    ) -> RagEntity:
        try:
            rag = RagRepository.create(
                user_id=user_id,
                name=name,
                description=description,
            )

            RagFileRepository.update_rag_files(rag_id=rag.id, rag_file_ids=rag_file_ids)

            rag_files = RagFile.objects.filter(id__in=rag_file_ids)

            all_chunks = []
            for rf in rag_files:
                chunks = RagFileService.load_and_split_document(
                    rf.public_url, rf.name, rf.public_url
                )
                all_chunks.extend(chunks)

            if all_chunks:
                create_or_update_faiss_vector_store(all_chunks, rag.id)
            return rag
        except Exception as e:
            # ImportError를 문자열로 변환하여 JSON 직렬화 가능하게 함
            if isinstance(e, ImportError):
                raise AppException(f"Import error: {str(e)}")
            else:
                raise AppException(f"Error creating RAG: {str(e)}")

    @staticmethod
    def get_by_id(id: uuid.UUID, user_id: uuid.UUID) -> Union[RagEntity, None]:
        return RagRepository.get_by_id(id, user_id)

    @staticmethod
    def update(
        id: uuid.UUID,
        user_id: uuid.UUID,
        name: Optional[str] = None,
        description: Optional[str] = None,
        rag_file_ids: Optional[List[uuid.UUID]] = None,
    ) -> Optional[RagEntity]:
        try:
            rag = Rag.objects.get(id=id, user_id=user_id)

            if name is not None:
                rag.name = name
            if description is not None:
                rag.description = description
            rag.save()

            if rag_file_ids:
                RagFileRepository.update_rag_files(
                    rag_id=rag.id, rag_file_ids=rag_file_ids
                )
                rag_files = RagFile.objects.filter(id__in=rag_file_ids)

                all_chunks = []
                for rf in rag_files:
                    chunks = RagFileService.load_and_split_document(
                        rf.public_url, rf.name, rf.public_url
                    )
                    all_chunks.extend(chunks)

                if all_chunks:
                    create_or_update_faiss_vector_store(
                        all_chunks,
                        rag.id,
                    )

            return RagRepository.get_by_id(id, user_id)
        except Rag.DoesNotExist:
            return None
        except Exception:
            raise

    @staticmethod
    def delete(id: uuid.UUID, user_id: uuid.UUID) -> bool:
        try:
            rag = Rag.objects.get(id=id, user_id=user_id)

            if rag.id:
                delete_faiss_vector_store(rag.id)

            RagFile.objects.filter(rag_id=id).update(rag_id=None)

            rag.delete()
            return True
        except Rag.DoesNotExist:
            return False
        except Exception:
            raise
