import { useState } from "react";

type ChatResponse = {
  recommended_title: string;
  short_reason: string;
  full_summary: string;
};

function App() {
  const [message, setMessage] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [result, setResult] = useState<ChatResponse | null>(null);

  const handleSend = async () => {
    if (!message.trim()) return;

    setLoading(true);
    setError("");
    setResult(null);

    try {
      const response = await fetch("http://127.0.0.1:8000/chat", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ message })
      });

      if (!response.ok) {
        throw new Error("Failed to fetch response from backend.");
      }

      const data: ChatResponse = await response.json();
      setResult(data);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={styles.page}>
      <div style={styles.card}>
        <h1 style={styles.title}>Smart Librarian</h1>
        <p style={styles.subtitle}>
          Ask for a book recommendation by theme or context.
        </p>

        <textarea
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          placeholder="Example: ce este 1984?"
          rows={5}
          style={styles.textarea}
        />

        <button onClick={handleSend} disabled={loading} style={styles.button}>
          {loading ? "Loading..." : "Send"}
        </button>

        {error && <p style={styles.error}>{error}</p>}

        {result && (
          <div style={styles.resultBox}>
            <h2 style={styles.sectionTitle}>Recommended Book</h2>
            <p style={styles.bookTitle}>{result.recommended_title}</p>

            <h3 style={styles.sectionTitle}>Why this book</h3>
            <p>{result.short_reason}</p>

            <h3 style={styles.sectionTitle}>Detailed Summary</h3>
            <p>{result.full_summary}</p>
          </div>
        )}
      </div>
    </div>
  );
}

const styles: Record<string, React.CSSProperties> = {
  page: {
    minHeight: "100vh",
    backgroundColor: "#f4f6f8",
    display: "flex",
    justifyContent: "center",
    alignItems: "center",
    padding: "24px",
    boxSizing: "border-box",
  },
  card: {
    width: "100%",
    maxWidth: "800px",
    backgroundColor: "#ffffff",
    borderRadius: "12px",
    padding: "24px",
    boxShadow: "0 8px 24px rgba(0, 0, 0, 0.08)",
    boxSizing: "border-box",
  },
  title: {
    margin: 0,
    marginBottom: "8px",
    fontSize: "32px",
  },
  subtitle: {
    marginTop: 0,
    marginBottom: "16px",
    color: "#555",
  },
  textarea: {
    width: "100%",
    padding: "12px",
    fontSize: "16px",
    borderRadius: "8px",
    border: "1px solid #ccc",
    resize: "vertical",
    marginBottom: "12px",
    boxSizing: "border-box",
  },
  button: {
    padding: "10px 18px",
    fontSize: "16px",
    borderRadius: "8px",
    border: "none",
    cursor: "pointer",
    backgroundColor: "#111827",
    color: "#ffffff",
  },
  error: {
    color: "crimson",
    marginTop: "12px",
  },
  resultBox: {
    marginTop: "24px",
    padding: "16px",
    borderRadius: "10px",
    backgroundColor: "#f9fafb",
    border: "1px solid #e5e7eb",
  },
  sectionTitle: {
    marginBottom: "8px",
  },
  bookTitle: {
    fontSize: "20px",
    fontWeight: 700,
    marginTop: 0,
  },
};

export default App;