from rest_framework.views import APIView
from rest_framework.response import Response
from apps.user.services import UserService
from core.constants.error_code import (
    MISSING_BASIC_AUTH,
    INVALID_CREDENTIAL,
    INVALID_AUTH_FORMAT,
    UNKNOWN_ERROR,
)
from apps.user.serializers import UserSerializer
from core.exceptions.app_exception import AppException
from core.utils.jwt import create_access_token, create_refresh_token
import base64

from rest_framework import status
from rest_framework.permissions import AllowAny


import logging

logger = logging.getLogger(__name__)


class LoginAPIView(APIView):
    def post(self, request):
        try:
            auth_header = request.headers.get("Authorization")
            if not auth_header or not auth_header.startswith("Basic "):
                raise AppException(
                    code=MISSING_BASIC_AUTH, status_code=status.HTTP_400_BAD_REQUEST
                )

            try:
                encoded = auth_header.split(" ")[1]
                decoded = base64.b64decode(encoded).decode("utf-8")
                email, password = decoded.split(":", 1)
            except Exception:
                raise AppException(
                    code=INVALID_AUTH_FORMAT, status_code=status.HTTP_400_BAD_REQUEST
                )

            user = UserService.login(email=email, password=password)
            if user is None:
                raise AppException(
                    code=INVALID_CREDENTIAL, status_code=status.HTTP_400_BAD_REQUEST
                )

            access_token = create_access_token(data={"sub": str(user.id)})
            refresh_token = create_refresh_token(data={"sub": str(user.id)})

            response_data = {
                "user": UserSerializer(user).data,
                "access_token": access_token,
                "refresh_token": refresh_token,
            }

            return Response(response_data, status=status.HTTP_200_OK)

        except AppException:
            raise
        except Exception as e:
            logger.exception(f"user login failed: {str(e)}")
            raise AppException(
                f"user login failed: {str(e)}",
                code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
