require 'httparty'
require 'dotenv'
require 'json'

Dotenv.load

API_KEY = ENV['GEMINI_API_KEY']
MODEL = ENV['MODEL']
ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/#{MODEL}:generateContent?key=#{API_KEY}"

def ask_gemini(prompt)
  headers = { "Content-Type" => "application/json" }
  body = {
    contents: [
      {
        parts: [
          { text: prompt }
        ]
      }
    ]
  }

  response = HTTParty.post(ENDPOINT, headers: headers, body: body.to_json)
  result = JSON.parse(response.body)

  if result["candidates"] && result["candidates"].first["content"]["parts"]
    result["candidates"].first["content"]["parts"].first["text"]
  else
    "Error: #{result}"
  end
end

# Example usage
puts "Ask Gemini something:"
print "> "
user_input = gets.chomp

response = ask_gemini(user_input)
puts "\nGemini says:\n#{response}"
