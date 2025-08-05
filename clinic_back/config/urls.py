from django.urls import path, include

urlpatterns = [
    path("api/v1/", include("apps.user.urls")),
    path("api/v1/", include("apps.rag.urls")),
]
