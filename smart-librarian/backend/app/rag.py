import json
from pathlib import Path
import chromadb
from app.data_loader import BOOKS
from app.openai_client import client
import os

chroma_client = chromadb.PersistentClient(path=str(Path(__file__).parent / "vectordb"))
collection = chroma_client.get_or_create_collection(name="book_summaries")

DATA_PATH = Path(__file__).parent / "data" / "book_summaries.json"

def embed_text(text: str):
    response = client.embeddings.create(
        model=os.getenv("EMBEDDING_MODEL", "text-embedding-3-small"),
        input=text
    )
    return response.data[0].embedding

def ingest_books():

    existing = collection.get()

    if existing["ids"]:
        collection.delete(ids=existing["ids"])

    for idx, book in enumerate(BOOKS):
        searchable_text = f"""
        Title: {book['title']}
        Short Summary: {book['short_summary']}
        Themes: {", ".join(book['themes'])}
        Detailed Summary: {book['detailed_summary']}
        """.strip()

        embedding = embed_text(searchable_text)

        collection.add(
            ids=[str(idx)],
            documents=[searchable_text],
            embeddings=[embedding],
            metadatas=[{"title": book["title"]}]
        )

def retrieve_books(query: str, k: int = 3):
    query_embedding = embed_text(query)
    results = collection.query(
        query_embeddings=[query_embedding],
        n_results=k
    )
    return results