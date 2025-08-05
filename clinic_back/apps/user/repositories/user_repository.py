from apps.user.models import User
from apps.user.entities import UserEntity
from django.core.exceptions import ObjectDoesNotExist
from django.contrib.auth.hashers import check_password
from typing import Optional


class UserRepository:
    @staticmethod
    def get_by_email(email: str) -> Optional[UserEntity]:
        try:
            user = User.objects.get(email=email)
            return UserEntity(
                id=user.id,
                email=user.email,
                name=user.name,
                password=user.password,
                profile_url=user.profile_url,
                wandb_apikey=user.wandb_apikey,
                created_at=user.created_at,
            )
        except ObjectDoesNotExist:
            return None

    @staticmethod
    def create(email: str, password: str, name: str) -> UserEntity:
        user = User(email=email, name=name)
        user.set_password(password)
        user.save()
        return UserEntity(
            id=user.id,
            email=user.email,
            name=user.name,
            password=user.password,
            profile_url=user.profile_url,
            wandb_apikey=user.wandb_apikey,
            created_at=user.created_at,
        )

    @staticmethod
    def verify_password(user: UserEntity, raw_password: str) -> bool:
        return check_password(raw_password, user.password)
