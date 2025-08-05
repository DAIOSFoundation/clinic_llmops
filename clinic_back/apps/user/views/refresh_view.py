from rest_framework.views import APIView
from rest_framework.response import Response
from core.exceptions.app_exception import AppException
from core.utils.jwt import refresh_access_token
from rest_framework import status
from rest_framework.permissions import AllowAny
import logging

logger = logging.getLogger(__name__)


class RefreshTokenAPIView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        try:
            refresh_token = request.data.get("refresh_token")
            if not refresh_token:
                raise AppException(
                    "Refresh token is required", status_code=status.HTTP_400_BAD_REQUEST
                )

            new_access_token = refresh_access_token(refresh_token)
            if not new_access_token:
                raise AppException(
                    "Invalid or expired refresh token",
                    status_code=status.HTTP_401_UNAUTHORIZED,
                )

            response_data = {
                "access_token": new_access_token,
            }

            return Response(response_data, status=status.HTTP_200_OK)

        except AppException:
            raise
        except Exception as e:
            logger.exception(f"Token refresh failed: {str(e)}")
            raise AppException(
                f"Token refresh failed: {str(e)}",
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

