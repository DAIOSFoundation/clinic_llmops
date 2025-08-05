from django.db import models
from django.utils import timezone

import uuid


class Rag(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user_id = models.UUIDField(null=False)
    name = models.CharField(max_length=128, null=False)
    description = models.TextField(blank=True, null=True)

    STATUS_CHOICES = [
        ("READY", "Ready"),
        ("Trained", "Trained"),
    ]
    status = models.CharField(
        max_length=20, choices=STATUS_CHOICES, default="Trained", null=False
    )

    VECTOR_STORE_CHOICES = [
        ("FAISS", "FAISS"),
        ("CHROMA", "CHROMA"),
    ]

    vector_store = models.CharField(
        max_length=50, choices=VECTOR_STORE_CHOICES, null=False, default="FAISS"
    )

    last_indexed_at = models.DateTimeField(blank=True, null=True)
    created_at = models.DateTimeField(default=timezone.now, null=False)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = "rags"
