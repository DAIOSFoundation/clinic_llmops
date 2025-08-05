from django.db import models
from django.utils import timezone
import uuid
from django.contrib.auth.hashers import make_password, check_password


class User(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True, max_length=128)
    name = models.CharField(max_length=64)
    password = models.CharField(max_length=255)
    profile_url = models.CharField(max_length=256, blank=True, null=True)
    wandb_apikey = models.CharField(max_length=128, blank=True, null=True)
    last_login = models.DateTimeField(blank=True, null=True)
    created_at = models.DateTimeField(default=timezone.now, null=False)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.email

    class Meta:
        db_table = "users"

    def set_password(self, raw_password: str):
        self.password = make_password(raw_password)

    def check_password(self, raw_password: str) -> bool:
        return check_password(raw_password, self.password)
