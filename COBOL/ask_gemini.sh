#!/bin/bash
# Load environment variables
export $(grep -v '^#' .env | xargs)

# Read prompt from file or stdin
PROMPT=$(cat input.txt)

# Call Gemini API
curl -s https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent?key=${GEMINI_API_KEY} \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{"parts":[{"text":"'"$PROMPT"'"}]}]
  }' | jq -r '.candidates[0].content.parts[0].text' > output.txt
