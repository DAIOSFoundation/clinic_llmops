"""
한국어 형태소 분석을 위한 유틸리티 함수
"""
import re
from typing import List, Set
from konlpy.tag import Okt

# Okt 형태소 분석기 초기화 (한 번만 초기화하여 성능 향상)
okt = Okt()

def extract_korean_keywords(text: str) -> Set[str]:
    """
    한국어 텍스트에서 키워드를 추출합니다.
    조사를 제거하고 명사, 형용사, 동사 어간을 추출합니다.
    
    Args:
        text (str): 분석할 한국어 텍스트
        
    Returns:
        Set[str]: 추출된 키워드 집합
    """
    if not text or not isinstance(text, str):
        return set()
    
    # 텍스트 정제 (특수문자 제거, 공백 정리)
    clean_text = re.sub(r'[^\w\s가-힣]', ' ', text)
    clean_text = re.sub(r'\s+', ' ', clean_text).strip()
    
    if not clean_text:
        return set()
    
    try:
        # 형태소 분석 수행 (norm=True로 정규화, stem=True로 어간 추출)
        morphs = okt.pos(clean_text, norm=True, stem=True)
        
        keywords = set()
        
        for word, pos in morphs:
            # 의미있는 품사만 선택 (명사, 형용사, 동사)
            if pos in ['Noun', 'Adjective', 'Verb'] and len(word) > 1:
                # 조사나 어미가 제거된 어간 형태로 저장
                keywords.add(word)
        
        # 추가: 원본 텍스트에서 2글자 이상의 연속된 한글 조합도 키워드로 추가
        # 이는 "하이코", "라라필" 같은 복합어를 보존하기 위함
        korean_words = re.findall(r'[가-힣]{2,}', clean_text)
        for word in korean_words:
            if len(word) >= 2:
                keywords.add(word)
        
        return keywords
        
    except Exception as e:
        # 형태소 분석 실패 시 기본 토큰화로 fallback
        print(f"형태소 분석 실패, 기본 토큰화 사용: {e}")
        return set(clean_text.lower().split())

def normalize_korean_text(text: str) -> str:
    """
    한국어 텍스트를 정규화합니다.
    
    Args:
        text (str): 정규화할 텍스트
        
    Returns:
        str: 정규화된 텍스트
    """
    if not text or not isinstance(text, str):
        return ""
    
    try:
        # Okt의 정규화 기능 사용
        normalized = okt.normalize(text)
        return normalized
    except Exception as e:
        # 정규화 실패 시 원본 반환
        print(f"텍스트 정규화 실패: {e}")
        return text

def get_korean_similarity_score(query_keywords: Set[str], doc_keywords: Set[str]) -> float:
    """
    한국어 키워드 간의 유사도 점수를 계산합니다.
    
    Args:
        query_keywords (Set[str]): 쿼리 키워드 집합
        doc_keywords (Set[str]): 문서 키워드 집합
        
    Returns:
        float: 유사도 점수 (0.0 ~ 1.0)
    """
    if not query_keywords or not doc_keywords:
        return 0.0
    
    # 교집합과 합집합 계산
    intersection = len(query_keywords.intersection(doc_keywords))
    union = len(query_keywords.union(doc_keywords))
    
    if union == 0:
        return 0.0
    
    # Jaccard 유사도
    jaccard_score = intersection / union
    
    # 키워드 포함 비율
    keyword_ratio = intersection / len(query_keywords) if query_keywords else 0.0
    
    # 종합 점수 (Jaccard 60% + 키워드 비율 40%)
    total_score = jaccard_score * 0.6 + keyword_ratio * 0.4
    
    return total_score 