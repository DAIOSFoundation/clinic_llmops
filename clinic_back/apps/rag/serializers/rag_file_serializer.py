from rest_framework import serializers
from apps.rag.models import RagFile


class RagFileSerializer(serializers.ModelSerializer):
    class Meta:
        model = RagFile
        fields = "__all__"


class RagFileUploadSerializer(serializers.Serializer):
    file = serializers.FileField(required=True)


class RagEmbeddingSerializer(serializers.Serializer):
    file = serializers.FileField(required=True)
    name = serializers.CharField()
