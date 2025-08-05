from django.db import models
from django.utils import timezone
from apps.rag.models.rag_model import Rag
import uuid


class RagFile(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    user_id = models.UUIDField(null=False)
    rag = models.ForeignKey(
        Rag,
        on_delete=models.CASCADE,
        related_name="files",
        null=True,
        blank=True,
    )
    name = models.CharField(max_length=255, null=False)
    public_url = models.TextField(null=False)
    hash = models.CharField(max_length=256, blank=True, null=True)
    created_at = models.DateTimeField(default=timezone.now, null=False)

    def __str__(self):
        return self.name

    class Meta:
        db_table = "rag_files"
