from app.data_loader import BOOK_SUMMARIES_DICT

def get_summary_by_title(title: str) -> str:
    return BOOK_SUMMARIES_DICT.get(title, "Summary not found for this title.")