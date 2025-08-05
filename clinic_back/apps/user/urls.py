from django.urls import path
from apps.user.views import LoginAPIView, RegisterAPIView, RefreshTokenAPIView

urlpatterns = [
    path(
        "users/login",
        LoginAPIView.as_view(),
    ),
    path(
        "users/register",
        RegisterAPIView.as_view(),
    ),
    path(
        "users/refresh",
        RefreshTokenAPIView.as_view(),
    ),
]
