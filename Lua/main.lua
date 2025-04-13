local gemini = require("gemini")

-- Load the environment variables
local dotenv = require("dotenv")
dotenv.load()

print("Gemini Chatbot")
print("Type your message (type 'exit' to quit)")

while true do
  io.write("> ")
  local user_input = io.read()

  if user_input == "exit" then break end

  local response = gemini.chat(user_input)

  if response then
    print("Gemini:", response)
  else
    print("Error getting response.")
  end
end
