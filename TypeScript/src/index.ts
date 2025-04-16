import readline from "readline";
import { chatWithGemini } from "./gemini";

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

console.log("💬 Gemini Chat Started. Gõ 'exit' để thoát.\n");

function askQuestion() {
  rl.question("Bạn: ", async (input) => {
    if (input.trim().toLowerCase() === "exit") {
      rl.close();
      return;
    }

    const response = await chatWithGemini(input);
    console.log("🤖 Gemini:", response, "\n");
    askQuestion();
  });
}

askQuestion();
