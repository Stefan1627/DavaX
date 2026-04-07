from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from app.rag import ingest_books
from app.chat_flow import run_chat_flow

app = FastAPI(title="Smart Librarian API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:5173", "http://127.0.0.1:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ChatRequest(BaseModel):
    message: str

@app.on_event("startup")
def startup_event():
    ingest_books()

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/chat")
def chat(req: ChatRequest):
    return run_chat_flow(req.message)