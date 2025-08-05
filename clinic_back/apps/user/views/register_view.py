from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from core.constants.error_code import (
    INVALID_REGISTER_FORMAT,
    EMAIL_ALREADY_EXISTS,
)
from rest_framework import serializers
from apps.user.serializers import UserSerializer
from core.exceptions.app_exception import AppException
from apps.user.services import UserService
from apps.user.serializers import RegisterSerializer
import logging


logger = logging.getLogger(__name__)


class RegisterAPIView(APIView):
    def post(self, request):
        try:
            serializer = RegisterSerializer(data=request.data)
            serializer.is_valid(raise_exception=True)

            email = serializer.validated_data["email"]
            name = serializer.validated_data["name"]
            password = serializer.validated_data["password"]

            existing_user = UserService.isExistEmail(email)
            if existing_user:
                raise AppException(
                    code=EMAIL_ALREADY_EXISTS, status_code=status.HTTP_400_BAD_REQUEST
                )

            user = UserService.register(email=email, password=password, name=name)

            return Response(UserSerializer(user).data, status=status.HTTP_201_CREATED)

        except serializers.ValidationError as e:
            logger.exception(f"user login validation error: {str(e)}")
            raise AppException(
                code=INVALID_REGISTER_FORMAT,
                status_code=status.HTTP_400_BAD_REQUEST,
            )
        except AppException:
            raise
        except Exception as e:
            logger.exception(f"user login failed: {str(e)}")
            raise AppException(
                f"user login failed: {str(e)}",
                code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
