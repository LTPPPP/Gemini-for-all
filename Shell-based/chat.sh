#!/bin/bash

# Load .env variables
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
else
  echo ".env file not found!"
  exit 1
fi

# Check if API key and model are set
if [ -z "$GEMINI_API_KEY" ] || [ -z "$MODEL" ]; then
  echo "GEMINI_API_KEY or MODEL not set in .env"
  exit 1
fi

# Function to make a chat request
chat_with_gemini() {
  local user_input="$1"

  curl -s -X POST \
    "https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${GEMINI_API_KEY}" \
    -H "Content-Type: application/json" \
    -d '{
          "contents": [{
            "role": "user",
            "parts": [{"text": "'"${user_input}"'"}]
          }]
        }' | jq -r '.candidates[0].content.parts[0].text'
}

echo "🔮 Gemini Chatbot (Model: $MODEL)"
echo "Type 'exit' to quit."
echo

while true; do
  read -rp "You: " input
  if [[ "$input" == "exit" ]]; then
    echo "Goodbye!"
    break
  fi

  response=$(chat_with_gemini "$input")
  echo -e "Gemini: $response\n"
done
