from rest_framework import serializers
from apps.rag.models import Rag, RagFile
from apps.rag.serializers.rag_file_serializer import RagFileSerializer


class RagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Rag
        fields = "__all__"


class RagFilesSerializer(serializers.ModelSerializer):
    files = serializers.SerializerMethodField()
    document_count = serializers.SerializerMethodField()
    total_size_mb = serializers.SerializerMethodField()

    class Meta:
        model = Rag
        fields = "__all__"

    def get_files(self, obj):
        rag_files = RagFile.objects.filter(rag_id=obj.id)
        return RagFileSerializer(rag_files, many=True).data
    
    def get_document_count(self, obj):
        return getattr(obj, 'document_count', 0)
    
    def get_total_size_mb(self, obj):
        return getattr(obj, 'total_size_mb', 0.0)


class RagCreateSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=128)
    description = serializers.CharField(required=False, allow_blank=True)
    rag_file_ids = serializers.ListField(
        child=serializers.UUIDField(),
        allow_empty=False,
    )


class RagPatchSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=128)
    description = serializers.CharField(required=False, allow_blank=True)
    rag_file_ids = serializers.ListField(
        child=serializers.UUIDField(),
        allow_empty=False,
    )


class RagDocumentSerializer(serializers.Serializer):
    page_content = serializers.CharField(help_text="문서 실제 내용")
    metadata = serializers.JSONField(help_text="문서의 메타데이터")
    score = serializers.FloatField(help_text="질문과 문서 간의 유사도", required=False)


class RagRetrieverResponseSerializer(serializers.Serializer):
    documents = RagDocumentSerializer(
        many=True, help_text="질문과 관련된 문서 조각 리스트"
    )
