import { GoogleGenerativeAI } from "@google/generative-ai";
import { Message } from "@/types";

// Define the Content and Part types if not already defined
type Part = { text: string };
type Content = { role: "user" | "model"; parts: Part[] };

// Initialize the Google Generative AI with API key
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "");

export async function getGeminiResponse(messages: Message[]): Promise<string> {
  try {
    // Get the model
    const model = genAI.getGenerativeModel({
      model: process.env.MODEL || "gemini-pro",
    });

    // Convert messages to the format expected by the API
    const chatHistory: Content[] = messages.slice(0, -1).map((msg) => ({
      role: msg.role === "user" ? "user" : "model",
      parts: [{ text: msg.content }] as Part[],
    }));

    // Start a chat
    const chat = model.startChat({
      history: chatHistory,
    });

    // Get the last user message
    const lastMessage = messages[messages.length - 1];
    if (lastMessage.role !== "user") {
      throw new Error("Last message must be from user");
    }

    // Send the message and get the response
    const result = await chat.sendMessage(lastMessage.content);
    const response = result.response.text();

    return response;
  } catch (error) {
    console.error("Error calling Gemini API:", error);
    throw new Error("Failed to get response from Gemini");
  }
}
