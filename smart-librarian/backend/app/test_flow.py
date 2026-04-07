from app.rag import ingest_books, retrieve_books
from app.recommender import recommend_book
from app.chat_flow import run_chat_flow

def main():
    print("== Ingesting books ==")
    ingest_books()

    print("\n== Retrieval test ==")
    retrieval = retrieve_books("I want a book about friendship and magic", k=3)
    print(retrieval["metadatas"][0])

    print("\n== Recommendation test ==")
    rec = recommend_book("I want a book about power and destiny")
    print(rec)

    print("\n== Full flow test ==")
    final = run_chat_flow("I want a book about war and trauma")
    print(final)

if __name__ == "__main__":
    main()