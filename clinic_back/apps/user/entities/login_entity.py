from dataclasses import dataclass
from datetime import datetime
from typing import Optional
from uuid import UUID


@dataclass
class LoginEntity:
    id: UUID
    name: str
    email: str
    profile_url: Optional[str]
    wandb_apikey: Optional[str]
    created_at: datetime
