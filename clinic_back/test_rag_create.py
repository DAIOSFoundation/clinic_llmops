#!/usr/bin/env python
import os
import sys
import django
import uuid

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from apps.rag.services import RagService
from apps.rag.models import RagFile
from apps.user.models import User

def test_rag_create():
    try:
        # 테스트 사용자 가져오기
        user = User.objects.get(email='test@example.com')
        print(f"✅ 사용자 찾음: {user.email}")
        
        # 실제 존재하는 rag_file_ids 가져오기
        rag_files = RagFile.objects.all()[:5]  # 처음 5개 파일 사용
        test_rag_file_ids = [rf.id for rf in rag_files]
        print(f"📁 실제 rag_file_ids: {test_rag_file_ids}")
        
        # RAG 생성 테스트
        rag = RagService.create(
            user_id=user.id,
            name="실제 파일로 테스트 RAG",
            description="실제 존재하는 파일로 RAG 생성 테스트",
            rag_file_ids=test_rag_file_ids
        )
        
        print(f"✅ RAG 생성 성공: {rag.id}")
        return rag
        
    except Exception as e:
        print(f"❌ RAG 생성 실패: {e}")
        import traceback
        traceback.print_exc()
        return None

if __name__ == '__main__':
    test_rag_create() 