import { GoogleGenerativeAI } from "@google/generative-ai";
import dotenv from "dotenv";

dotenv.config();

const apiKey = process.env.GEMINI_API_KEY!;
const modelName = process.env.MODEL || "gemini-2.0-flash";

const genAI = new GoogleGenerativeAI(apiKey);
const model = genAI.getGenerativeModel({ model: modelName });

export async function chatWithGemini(message: string): Promise<string> {
  try {
    const result = await model.generateContent(message);
    const response = await result.response;
    return response.text();
  } catch (error: any) {
    return `❌ Error: ${error.message}`;
  }
}
