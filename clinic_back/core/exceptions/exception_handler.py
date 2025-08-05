from rest_framework.views import exception_handler as drf_exception_handler
from rest_framework.response import Response
from rest_framework.exceptions import APIException
from core.constants.error_code import (
    get_error_message,
    UNKNOWN_ERROR,
    INTERNAL_SERVER_ERROR,
)


def base_exception_handler(exc, context):
    response = drf_exception_handler(exc, context)

    if response is not None:
        code = getattr(exc, "default_code", UNKNOWN_ERROR)
        message = str(exc.detail) if hasattr(exc, "detail") else get_error_message(code)

        return Response(
            {
                "error": {
                    "code": code.upper(),
                    "message": message,
                }
            },
            status=response.status_code,
        )

    if isinstance(exc, Exception):
        code = getattr(exc, "code", UNKNOWN_ERROR)
        message = getattr(exc, "message", get_error_message(code))
        status = getattr(exc, "status_code", 500)

        return Response(
            {
                "error": {
                    "code": code,
                    "message": message,
                }
            },
            status=status,
        )

    return Response(
        {
            "error": {
                "code": INTERNAL_SERVER_ERROR,
                "message": get_error_message(INTERNAL_SERVER_ERROR),
            }
        },
        status=500,
    )
