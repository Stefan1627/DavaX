import json
from pathlib import Path

DATA_PATH = Path(__file__).parent / "data" / "book_summaries.json"

with open(DATA_PATH, "r", encoding="utf-8") as f:
    BOOKS = json.load(f)

BOOK_SUMMARIES_DICT = {book["title"]: book["detailed_summary"] for book in BOOKS}