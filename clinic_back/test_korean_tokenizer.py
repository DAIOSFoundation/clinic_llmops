#!/usr/bin/env python3
"""
한국어 형태소 분석 테스트 스크립트
"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from core.utils.korean_tokenizer import extract_korean_keywords, get_korean_similarity_score

def test_korean_tokenizer():
    """한국어 형태소 분석 테스트"""
    
    # 테스트 케이스들
    test_cases = [
        "하이코란",
        "하이코가 뭐야",
        "라라필이 뭐야",
        "보톡스 효과",
        "필러 시술",
        "피부 관리",
        "화장품 추천"
    ]
    
    print("=== 한국어 형태소 분석 테스트 ===\n")
    
    for query in test_cases:
        keywords = extract_korean_keywords(query)
        print(f"질문: {query}")
        print(f"추출된 키워드: {keywords}")
        print("-" * 50)
    
    # 유사도 테스트
    print("\n=== 키워드 유사도 테스트 ===\n")
    
    query1 = "하이코란"
    query2 = "하이코가 뭐야"
    
    keywords1 = extract_korean_keywords(query1)
    keywords2 = extract_korean_keywords(query2)
    
    similarity = get_korean_similarity_score(keywords1, keywords2)
    
    print(f"질문 1: {query1} → 키워드: {keywords1}")
    print(f"질문 2: {query2} → 키워드: {keywords2}")
    print(f"유사도 점수: {similarity:.3f}")
    print("-" * 50)

if __name__ == "__main__":
    test_korean_tokenizer() 