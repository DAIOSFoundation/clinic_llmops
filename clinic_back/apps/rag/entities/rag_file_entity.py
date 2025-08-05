from dataclasses import dataclass
from datetime import datetime
from typing import Optional

import uuid


@dataclass
class RagFileEntity:
    id: uuid.UUID
    rag_id: uuid.UUID
    user_id: uuid.UUID
    name: str
    public_url: str
    created_at: datetime
    file_hash: Optional[str] = None


@dataclass
class RagFileUploadEntity:
    id: uuid.UUID
    name: str
    user_id: uuid.UUID
    public_url: str
    created_at: datetime
