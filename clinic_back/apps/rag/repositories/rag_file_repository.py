from datetime import datetime
from apps.rag.entities import RagFileUploadEntity
from apps.rag.entities import RagEntity
from django.conf import settings
from django.core.files.storage import default_storage
from django.core.files.uploadedfile import UploadedFile
from django.db import transaction
from apps.rag.models import RagFile
from django.core.files.base import ContentFile
import os
from core.exceptions.app_exception import AppException

import uuid
from typing import List


class RagFileRepository:
    @staticmethod
    def create(uploaded_file: UploadedFile, user_id: uuid.UUID) -> RagFileUploadEntity:
        try:
            original_file_name = uploaded_file.name
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            save_path = f"rag_files/{timestamp}_{original_file_name}"

            upload_dir = "uploads"
            os.makedirs(upload_dir, exist_ok=True)
            file_path = os.path.join(upload_dir, original_file_name)

            with open(file_path, "wb+") as destination:
                for chunk in uploaded_file.chunks():
                    destination.write(chunk)

            public_url = file_path

            with transaction.atomic():
                rag_file = RagFile.objects.create(
                    user_id=user_id,
                    name=original_file_name,
                    public_url=public_url,
                )
            return RagFileUploadEntity(
                id=rag_file.id,
                name=rag_file.name,
                user_id=user_id,
                public_url=public_url,
                created_at=rag_file.created_at,
            )

        except Exception as e:
            raise AppException(f"Failed RagFile upload: {e}")

    @staticmethod
    def update_rag_files(rag_id: uuid.UUID, rag_file_ids: List[uuid.UUID]) -> None:
        RagFile.objects.filter(id__in=rag_file_ids).update(rag_id=rag_id)
