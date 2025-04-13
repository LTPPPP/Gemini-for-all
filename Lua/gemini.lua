local https = require("ssl.https")
local json = require("dkjson")

local function chat(prompt)
  local api_key = os.getenv("GEMINI_API_KEY")
  local model = os.getenv("MODEL") or "gemini-pro"
  local url = "https://generativelanguage.googleapis.com/v1beta/models/" .. model .. ":generateContent?key=" .. api_key

  local payload = {
    contents = {
      {
        role = "user",
        parts = {
          { text = prompt }
        }
      }
    }
  }

  local body = json.encode(payload)
  local response_body = {}

  local res, code, headers, status = https.request{
    url = url,
    method = "POST",
    headers = {
      ["Content-Type"] = "application/json",
      ["Content-Length"] = tostring(#body)
    },
    source = ltn12.source.string(body),
    sink = ltn12.sink.table(response_body)
  }

  if code == 200 then
    local full_response = json.decode(table.concat(response_body))
    local text = full_response.candidates and full_response.candidates[1].content.parts[1].text
    return text
  else
    print("HTTP error:", code, status)
    return nil
  end
end

return {
  chat = chat
}
