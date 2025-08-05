from apps.user.repositories import UserRepository
from apps.user.entities import UserEntity
from apps.user.entities import LoginEntity
from typing import Optional


class UserService:
    @staticmethod
    def login(email: str, password: str) -> Optional[LoginEntity]:
        user_entity = UserRepository.get_by_email(email)
        if not user_entity:
            return None

        if not UserRepository.verify_password(user_entity, password):
            return None

        return LoginEntity(
            id=user_entity.id,
            name=user_entity.name,
            email=user_entity.email,
            profile_url=user_entity.profile_url,
            wandb_apikey=user_entity.wandb_apikey,
            created_at=user_entity.created_at,
        )

    @staticmethod
    def register(email: str, password: str, name: str) -> UserEntity:
        return UserRepository.create(email, password, name)

    @staticmethod
    def isExistEmail(email: str) -> bool:
        user = UserRepository.get_by_email(email)
        return user is not None
