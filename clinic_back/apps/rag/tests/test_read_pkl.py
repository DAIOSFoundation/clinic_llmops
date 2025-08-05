import pickle

with open("../../../vectorstore/food/index.pkl", "rb") as f:
    data = pickle.load(f)

index, docstore = data
print(f"📦 문서 개수: {len(docstore)}")

for i, doc in enumerate(docstore.values(), 1):
    print(f"\n[{i}] ===============================")
    print(f"📄 내용:\n{doc.page_content[:1200]}")
