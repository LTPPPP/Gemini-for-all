#!/bin/bash

# Load .env variables
set -a
source .env
set +a

# Read user prompt from file
PROMPT=$(cat prompt.txt)

# Send request to Gemini API using cURL
curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/${MODEL}:generateContent?key=${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [
      {
        "parts": [
          {
            "text": "'"${PROMPT}"'"
          }
        ]
      }
    ]
  }' | jq '.candidates[0].content.parts[0].text'
