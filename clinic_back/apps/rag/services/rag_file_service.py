from django.core.exceptions import ObjectDoesNotExist
from apps.rag.repositories import RagFileRepository
from apps.rag.entities import RagFileUploadEntity
from django.core.files.uploadedfile import UploadedFile
from langchain_community.document_loaders import (
    PyPDFLoader,
    TextLoader,
    JSONLoader,
    CSVLoader,
)
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_core.documents import Document
import os

import json
from core.exceptions.app_exception import AppException
import uuid


class RagFileService:
    @staticmethod
    def upload(uploaded_file: UploadedFile, user_id: uuid.UUID) -> RagFileUploadEntity:
        return RagFileRepository.create(uploaded_file, user_id)

    @staticmethod
    def load(file_path: str):
        file_extension = os.path.splitext(file_path)[1].lower()

        if file_extension == ".pdf":
            loader = PyPDFLoader(file_path)
        elif file_extension == ".txt":
            loader = TextLoader(file_path)
        elif file_extension == ".json":
            jq_schema = """
            .[] | {
            page_content: (
                "질문: " + ((.question // []) | join("\\n")) + "\\n" +
                "답변: " + ((.answer // []) | join("\\n")) + "\\n" +
                "설명: " + (.description // "")
            ),
            metadata: {
                step_id: .step_id,
                process_name: .process_name,
                api_url: .api.url,
                api_method: .api.method
            }
            }
            """

            def _metadata_func(record, metadata):
                return {
                    **metadata,
                    "step_id": record.get("step_id"),
                    "process_name": record.get("process_name"),
                    "api_url": (record.get("api") or {}).get("url"),
                    "api_method": (record.get("api") or {}).get("method"),
                }

            loader = JSONLoader(
                file_path=file_path,
                jq_schema=jq_schema,
                content_key="page_content",
                metadata_func=_metadata_func,
                text_content=True,
            )
        elif file_extension == ".csv":
            try:
                loader = CSVLoader(
                    file_path, encoding="cp949", csv_args={"delimiter": ","}
                )
                temp_docs = loader.load()
                if not temp_docs or not any(d.page_content for d in temp_docs):
                    raise UnicodeDecodeError(
                        "cp949 resulted in empty content, trying utf-8"
                    )
            except UnicodeDecodeError:
                try:
                    loader = CSVLoader(
                        file_path, encoding="utf-8", csv_args={"delimiter": ","}
                    )
                    temp_docs = loader.load()
                    if not temp_docs or not any(d.page_content for d in temp_docs):
                        raise UnicodeDecodeError(
                            "utf-8 resulted in empty content, trying utf-8-sig"
                        )
                except UnicodeDecodeError:
                    loader = CSVLoader(
                        file_path, encoding="utf-8-sig", csv_args={"delimiter": ","}
                    )
            except Exception as e:
                raise ValueError(
                    f"Could not determine correct encoding for CSV file: {file_path}"
                ) from e

        if loader:
            return loader.load()
        else:
            raise ValueError("Unsupported file extension")

    @staticmethod
    def load_and_split_document(
        file_path: str, original_file_name: str = None, file_url: str = None
    ):
        try:
            documents = RagFileService.load(file_path)

            for doc in documents:
                if file_url:
                    doc.metadata["file_url"] = file_url

                if "source" in doc.metadata and doc.metadata["source"] == file_path:
                    if original_file_name:
                        doc.metadata["source"] = original_file_name

            text_splitter = RecursiveCharacterTextSplitter(
                chunk_size=2000,
                chunk_overlap=300,
                length_function=len,
                is_separator_regex=False,
            )
            chunks = text_splitter.split_documents(documents)
            return chunks
        except Exception as e:
            raise AppException(e)
