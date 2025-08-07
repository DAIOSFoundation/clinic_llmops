# import spacy  # 주석 처리
from sentence_transformers import SentenceTransformer
from django.conf import settings
import logging
from langchain_huggingface import HuggingFaceEmbeddings
import fasttext
import os

# import google.generativeai as genai  # 주석 처리
from typing import Dict, List, Literal, TypedDict, Optional

logger = logging.getLogger(__name__)

_sentence_transformer_instance = None
_spacy_ner_instance = None
_huggingface_embeddings_instance = None
_fasttext_model_instance = None


def load_all_models():
    try:
        if os.environ.get("RUN_MAIN", None) != "true":
            return

        print("⏳ 모든 모델 초기화 시작")
        get_sentence_transformer_model()
        # get_spacy_model()
        get_huggingface_embeddings_model()
        get_fasttext_model()
        print("✅ 모든 모델 초기화 완료")
    except Exception as e:
        print(f"❌ 모델 초기화 중 오류 발생: {e}")


def get_sentence_transformer_model():
    global _sentence_transformer_instance
    if _sentence_transformer_instance is None:
        try:
            model_name = settings.SENTENCE_TRANSFORMER_MODEL
            _sentence_transformer_instance = SentenceTransformer(model_name)
            logger.info(f"✅ SentenceTransformer 모델 '{model_name}' 로드 완료")
        except Exception as e:
            logger.error(f"❌ SentenceTransformer 모델 로드 실패: {e}")
            _sentence_transformer_instance = None
            raise RuntimeError(f"SentenceTransformer 모델을 로드할 수 없습니다: {e}")
    return _sentence_transformer_instance


def get_huggingface_embeddings_model():
    global _huggingface_embeddings_instance
    if _huggingface_embeddings_instance is None:
        try:
            model_full_name = settings.SENTENCE_TRANSFORMER_MODEL

            logger.info(f"⏳ HuggingFaceEmbeddings 모델 로딩 시작: {model_full_name}")
            _huggingface_embeddings_instance = HuggingFaceEmbeddings(
                model_name=model_full_name
            )
            logger.info("✅ HuggingFaceEmbeddings 모델 로드 완료")
        except Exception as e:
            logger.error(f"❌ HuggingFaceEmbeddings 모델 로드 실패: {e}")
            _huggingface_embeddings_instance = None
            raise RuntimeError(f"임베딩 모델을 로드할 수 없습니다: {e}")
    return _huggingface_embeddings_instance


def get_fasttext_model():
    global _fasttext_model_instance
    if _fasttext_model_instance is None:
        try:
            # 온라인 모델 사용
            model_name = settings.FASTTEXT_MODEL
            logger.info(f"⏳ FastText 모델 로딩 시작 (온라인): {model_name}")
            _fasttext_model_instance = fasttext.load_model(model_name)
            logger.info("✅ FastText 모델 로드 완료")
        except ValueError as ve:
            logger.error(f"❌ FastText 모델 로드 실패 (파일 없음 또는 손상): {ve}")
            _fasttext_model_instance = None
            raise RuntimeError(f"FastText 모델을 로드할 수 없습니다: {ve}")
        except Exception as e:
            logger.error(f"❌ FastText 모델 로드 중 예상치 못한 오류 발생: {e}")
            _fasttext_model_instance = None
            raise RuntimeError(f"FastText 모델을 로드할 수 없습니다: {e}")
    return _fasttext_model_instance

