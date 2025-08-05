from dataclasses import dataclass
from datetime import datetime
from typing import Optional
from uuid import UUID


@dataclass
class UserEntity:
    id: UUID
    name: str
    email: str
    password: str
    profile_url: Optional[str]
    wandb_apikey: Optional[str]
    created_at: datetime
