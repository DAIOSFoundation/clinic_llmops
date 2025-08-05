#!/usr/bin/env python
import os
import sys
import django

# Django 설정 로드
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from apps.user.models import User
from django.utils import timezone

def create_test_user():
    """테스트 사용자를 생성합니다."""
    try:
        # 기존 사용자 확인
        user, created = User.objects.get_or_create(
            email='test@example.com',
            defaults={
                'name': '테스트 사용자',
                'password': 'test1234',
                'profile_url': '',
                'wandb_apikey': '',
                'last_login': timezone.now(),
            }
        )
        
        if created:
            user.set_password('test1234')
            user.save()
            print(f"✅ 테스트 사용자가 생성되었습니다: {user.email}")
        else:
            print(f"ℹ️  테스트 사용자가 이미 존재합니다: {user.email}")
            
        return user
        
    except Exception as e:
        print(f"❌ 사용자 생성 중 오류 발생: {e}")
        return None

if __name__ == '__main__':
    create_test_user() 