from apps.rag.models import Rag, RagFile
from apps.rag.entities import RagEntity, RagFileEntity

from typing import Optional, List

import uuid


class RagRepository:
    @staticmethod
    def to_entity(rag: Rag, files: Optional[List[RagFileEntity]] = None) -> RagEntity:
        return RagEntity(
            id=rag.id,
            user_id=rag.user_id,
            name=rag.name,
            description=rag.description,
            status=rag.status,
            vector_store=rag.vector_store,
            last_indexed_at=rag.last_indexed_at,
            created_at=rag.created_at,
            updated_at=rag.updated_at,
            files=files if files is not None else [],
        )

    @staticmethod
    def get_all(user_id: uuid.UUID) -> list[RagEntity]:
        try:
            rags = Rag.objects.filter(user_id=user_id).order_by("-created_at")
            return [RagRepository.to_entity(rag) for rag in rags]
        except:
            raise

    @staticmethod
    def create(
        user_id: uuid.UUID,
        name: str,
        description: str,
    ) -> RagEntity:
        try:
            rag = Rag.objects.create(
                user_id=user_id,
                name=name,
                description=description,
            )
            return RagRepository.to_entity(rag)
        except:
            raise

    @staticmethod
    def get_by_id(id: uuid.UUID, user_id: uuid.UUID) -> Optional[RagEntity]:
        try:
            rag = Rag.objects.get(id=id, user_id=user_id)
            rag_files = RagFile.objects.filter(rag_id=id)
            file_entities = [
                RagFileEntity(
                    id=rf.id,
                    rag_id=rf.rag_id,
                    user_id=rf.user_id,
                    name=rf.name,
                    public_url=rf.public_url,
                    created_at=rf.created_at,
                )
                for rf in rag_files
            ]
            return RagRepository.to_entity(rag, files=file_entities)
        except Rag.DoesNotExist:
            return None
        except Exception as e:
            print(f"Error getting Rag by ID {id}: {e}")
            return None

            print(e)
