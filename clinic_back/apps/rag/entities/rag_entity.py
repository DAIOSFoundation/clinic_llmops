from dataclasses import dataclass
from datetime import datetime
from typing import Optional, List
from apps.rag.entities.rag_file_entity import RagFileEntity

import uuid


@dataclass
class RagEntity:
    id: uuid.UUID
    user_id: uuid.UUID
    name: str
    description: Optional[str]
    status: str
    vector_store: str
    created_at: datetime
    updated_at: datetime
    last_indexed_at: Optional[datetime]
    files: Optional[List[RagFileEntity]] = None
