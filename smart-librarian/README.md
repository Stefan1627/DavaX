# Smart Librarian

Smart Librarian is a full-stack AI project that recommends books based on the user’s interests using **RAG (Retrieval-Augmented Generation)** and a **tool-calling flow**.

The application uses:

- **React + TypeScript** for the frontend
- **FastAPI** for the backend
- **ChromaDB** as the vector database
- **OpenAI embeddings** for semantic search
- **OpenAI Chat API** for recommendation generation
- a local Python tool `get_summary_by_title(title)` to fetch the full summary of the recommended book

The goal of the project is to allow a user to ask for books by theme or context, for example:

- “I want a book about friendship and magic”
- “What do you recommend for someone who loves war stories?”
- “Ce este 1984?”

The system retrieves the most relevant books from a local vector database, recommends one title, then automatically fetches and returns the detailed summary for that exact title.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [How the Application Works](#how-the-application-works)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Environment Variables](#environment-variables)
- [Backend Setup](#backend-setup)
- [Frontend Setup](#frontend-setup)
- [How to Run the Project](#how-to-run-the-project)
- [API Endpoints](#api-endpoints)
- [How to Use the Application](#how-to-use-the-application)
- [Example Prompts](#example-prompts)
- [Tool Function](#tool-function)
- [RAG Flow Explanation](#rag-flow-explanation)
- [Notes About the Vector Store](#notes-about-the-vector-store)
- [Troubleshooting](#troubleshooting)
- [Possible Improvements](#possible-improvements)

---

## Project Overview

This project implements a **Smart Librarian** chatbot that uses a local book dataset and semantic retrieval to recommend books.

The workflow is:

1. Load book summaries from a local JSON file.
2. Convert book descriptions into embeddings using OpenAI.
3. Store the vectors in **ChromaDB**.
4. Accept a user query from the frontend.
5. Retrieve the most relevant books from the vector database.
6. Send the retrieved context to the LLM.
7. Let the LLM recommend one book.
8. Automatically call the tool `get_summary_by_title(title)`.
9. Return the recommendation and full summary to the frontend.

This combines **RAG** and **tool completion** in a simple browser-based application.

---

## Architecture

The project is split into two parts:

### Backend
The backend is responsible for:

- loading the book dataset
- creating embeddings
- storing and querying the vector database
- calling the OpenAI chat model
- executing the local tool
- exposing API endpoints to the frontend

### Frontend
The frontend is responsible for:

- collecting the user’s message
- sending it to the backend
- displaying the recommended title
- displaying the reason for the recommendation
- displaying the full detailed summary

---

## Project Structure

```text
smart-librarian/
│
├── backend/
│   ├── app/
│   │   ├── data/
│   │   │   └── book_summaries.json
│   │   ├── vectordb/
│   │   ├── main.py
│   │   ├── rag.py
│   │   ├── recommender.py
│   │   ├── chat_flow.py
│   │   ├── tools.py
│   │   ├── prompts.py
│   │   └── openai_client.py
│   ├── .env
│   └── requirements.txt
│
├── frontend/
│   ├── src/
│   │   ├── App.tsx
│   │   ├── main.tsx
│   │   └── index.css
│   ├── package.json
│   └── vite.config.ts
│
└── README.md

---

## How to build the app

### Prerequisites
- Python 3.8+
- Node.js 14+
- An OpenAI API key

### Environment Variables
Create a `.env` file in the `backend/` directory with the following content:

```env
OPENAI_API_KEY=your_api_key_here
```
### Backend Setup
1. Navigate to the `backend/` directory:
```bash
cd backend
```
2. Create a virtual environment and activate it:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```
3. Install the required dependencies:
```bash
pip install -r requirements.txt
```

## How to run the app

1. Start the backend server:
```bash
uvicorn app.main:app --reload
```
2. In a new terminal, navigate to the `frontend/` directory:
```bash
cd frontend
```
3. Install the frontend dependencies:
```bash
npm install
```
4. Start the frontend development server:
```bash
npm run dev
```
5. Open your browser and go to `http://localhost:5173` to interact with the Smart Librarian.
