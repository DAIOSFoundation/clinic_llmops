from langchain.document_loaders import JSONLoader
import jq
import json

# 1. 원본 JSON 로드
with open("data.json", "r", encoding="utf-8") as f:
    raw_data = json.load(f)

# 2. jq 실행
jq_schema = """
.[] | {
  page_content: (
    "질문: " + ((.question // []) | join("\\n")) + "\\n" +
    "답변: " + ((.answer // []) | join("\\n")) + "\\n" +
    "설명: " + ((.description // "") | tostring)
  ),
  metadata: {
    step_id: .step_id,
    process_name: .process_name,
    api_url: .api.url,
    api_method: .api.method
  }
}
"""
parsed = jq.compile(jq_schema).input(raw_data).all()

# 3. page_content 타입 확인
for item in parsed:
    print(type(item["page_content"]))  # 반드시 <class 'str'> 이어야 함
    print(item["page_content"])
