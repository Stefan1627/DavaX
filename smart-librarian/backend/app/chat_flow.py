from app.recommender import recommend_book_with_tool

def run_chat_flow(user_query: str):
    return recommend_book_with_tool(user_query)