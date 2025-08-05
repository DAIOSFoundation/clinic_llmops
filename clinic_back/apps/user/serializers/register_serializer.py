from rest_framework import serializers
import re


class RegisterSerializer(serializers.Serializer):
    email = serializers.EmailField(max_length=128)
    name = serializers.CharField(max_length=64)
    password = serializers.CharField(write_only=True, min_length=8)

    def validate_email(self, value):
        if not re.match(r"[^@]+@[^@]+\.[^@]+", value):
            raise serializers.ValidationError("올바른 이메일 형식이 아닙니다.")
        return value

    def validate_password(self, value):
        if not re.search(r"[A-Za-z]", value) or not re.search(r"\d", value):
            raise serializers.ValidationError(
                "비밀번호는 문자와 숫자의 조합이어야 합니다."
            )
        return value
