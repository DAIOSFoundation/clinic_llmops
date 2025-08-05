from django.core.files.base import ContentFile
from django.core.files.storage import default_storage


def test_gcs_upload():
    test_file_path = "rag_files/test_gcs.txt"
    test_file_content = ContentFile(b"Test GCS upload content")

    saved_path = default_storage.save(test_file_path, test_file_content)
    print("✅ GCS Uploaded to:", saved_path)
    print("📎 Public URL:", default_storage.url(saved_path))
