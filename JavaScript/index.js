import dotenv from "dotenv";
import fetch from "node-fetch";
import readlineSync from "readline-sync";

dotenv.config();

const API_KEY = process.env.GEMINI_API_KEY;
const MODEL = process.env.MODEL || "gemini-pro";
const BASE_URL = `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${API_KEY}`;

async function chatWithGemini(message) {
  const body = {
    contents: [
      {
        parts: [{ text: message }],
      },
    ],
  };

  const response = await fetch(BASE_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    console.error("Error from Gemini API:", await response.text());
    return "Error from Gemini API.";
  }

  const data = await response.json();
  return (
    data?.candidates?.[0]?.content?.parts?.[0]?.text || "[No reply from Gemini]"
  );
}

async function main() {
  console.log("🧠 Gemini Chatbot - type 'exit' to quit");

  while (true) {
    const userInput = readlineSync.question("\nYou: ");
    if (userInput.toLowerCase() === "exit") break;

    const reply = await chatWithGemini(userInput);
    console.log("\nGemini:", reply);
  }
}

main();
