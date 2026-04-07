import json
import os
from app.rag import retrieve_books
from app.prompts import SYSTEM_PROMPT
from app.openai_client import client
from app.tools import get_summary_by_title

TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "get_summary_by_title",
            "description": "Returns the full detailed summary for an exact book title.",
            "parameters": {
                "type": "object",
                "properties": {
                    "title": {
                        "type": "string",
                        "description": "Exact title of the recommended book"
                    }
                },
                "required": ["title"]
            }
        }
    }
]

def recommend_book_with_tool(user_query: str):
    results = retrieve_books(user_query, k=3)
    docs = results["documents"][0]
    titles = [m["title"] for m in results["metadatas"][0]]

    context = "\n\n".join(docs)

    messages = [
        {"role": "system", "content": SYSTEM_PROMPT},
        {
            "role": "user",
            "content": (
                f"User request: {user_query}\n\n"
                f"Retrieved titles: {titles}\n\n"
                f"Retrieved context:\n{context}"
            )
        }
    ]

    first_response = client.chat.completions.create(
        model=os.getenv("CHAT_MODEL", "gpt-4o-mini"),
        messages=messages,
        tools=TOOLS,
        tool_choice="auto",
        temperature=0
    )

    first_message = first_response.choices[0].message

    if not first_message.tool_calls:
        fallback_title = titles[0]
        fallback_summary = get_summary_by_title(fallback_title)

        return {
            "recommended_title": fallback_title,
            "short_reason": "Recommended from retrieved context.",
            "full_summary": fallback_summary
        }

    tool_call = first_message.tool_calls[0]
    function_name = tool_call.function.name
    function_args = json.loads(tool_call.function.arguments)

    title = function_args.get("title", titles[0])

    if title not in titles:
        title = titles[0]

    tool_result = get_summary_by_title(title)

    messages.append(
        {
            "role": "assistant",
            "tool_calls": [
                {
                    "id": tool_call.id,
                    "type": "function",
                    "function": {
                        "name": function_name,
                        "arguments": json.dumps({"title": title})
                    }
                }
            ]
        }
    )

    messages.append(
        {
            "role": "tool",
            "tool_call_id": tool_call.id,
            "content": tool_result
        }
    )

    messages.append(
        {
            "role": "user",
            "content": (
                "Now return ONLY valid JSON in this exact format:\n"
                '{'
                '"recommended_title": "Exact title", '
                '"short_reason": "One short reason", '
                '"full_summary": "Detailed summary text"'
                '}\n'
                "Do not include markdown. Do not include extra text."
            )
        }
    )

    final_response = client.chat.completions.create(
        model=os.getenv("CHAT_MODEL", "gpt-4o-mini"),
        messages=messages,
        temperature=0
    )

    raw_text = final_response.choices[0].message.content
    parsed = json.loads(raw_text)

    recommended_title = parsed.get("recommended_title", title)
    short_reason = parsed.get("short_reason", "Recommended from retrieved context.")
    full_summary = parsed.get("full_summary", tool_result)

    if recommended_title not in titles:
        recommended_title = title

    return {
        "recommended_title": recommended_title,
        "short_reason": short_reason,
        "full_summary": full_summary
    }