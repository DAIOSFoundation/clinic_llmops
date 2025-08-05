from django.urls import path
from apps.rag.views import (
    RagFileAPIView,
    RagAPIView,
    RagVectorStoreAPIView,
)

urlpatterns = [
    path(
        "rags/file/upload",
        RagFileAPIView.as_view(),
    ),
    path(
        "rags",
        RagAPIView.as_view(),
    ),
    path(
        "rags/retriever/<str:name>",
        RagVectorStoreAPIView.as_view(),
    ),
    path(
        "rags/<id>",
        RagAPIView.as_view(),
    ),
]
