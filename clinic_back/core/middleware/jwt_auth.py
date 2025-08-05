import jwt
from django.conf import settings
from django.http import JsonResponse
from jwt.exceptions import InvalidTokenError, ExpiredSignatureError


class JWTAuthMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        auth_header = request.headers.get("Authorization")

        if auth_header and auth_header.startswith("Bearer "):
            token = auth_header.split(" ")[1]
            try:
                payload = jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])
                request.user_payload = payload
            except ExpiredSignatureError:
                return JsonResponse({"error": "Token has expired"}, status=401)
            except InvalidTokenError:
                return JsonResponse({"error": "Invalid token"}, status=401)

        return self.get_response(request)
