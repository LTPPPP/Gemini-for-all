DECLARE FUNCTION ReadEnvValue$(BYVAL key$)
DECLARE FUNCTION CallGeminiAPI$(BYVAL prompt$, BYVAL apiKey$, BYVAL model$)

DIM prompt AS STRING
DIM apiKey AS STRING
DIM model AS STRING
DIM response AS STRING

' Read API Key and Model from .env file
apiKey = ReadEnvValue("GEMINI_API_KEY")
model = ReadEnvValue("MODEL")

PRINT "Enter your prompt for Gemini:"
LINE INPUT prompt

response = CallGeminiAPI(prompt, apiKey, model)

PRINT "Gemini says:"
PRINT response
END

' ----------- Functions -----------

FUNCTION ReadEnvValue$ (key$)
    DIM line AS STRING
    DIM value$ AS STRING
    OPEN ".env" FOR INPUT AS #1
    DO WHILE NOT EOF(1)
        LINE INPUT #1, line
        IF LEFT$(line, LEN(key$) + 1) = key$ + "=" THEN
            value$ = MID$(line, LEN(key$) + 2)
            EXIT DO
        END IF
    LOOP
    CLOSE #1
    ReadEnvValue$ = value$
END FUNCTION

FUNCTION CallGeminiAPI$ (prompt$, apiKey$, model$)
    ' Write prompt to temporary file
    DIM command AS STRING
    DIM tmpInputFile AS STRING
    DIM tmpOutputFile AS STRING
    tmpInputFile = "prompt.json"
    tmpOutputFile = "response.txt"

    ' Write JSON prompt
    OPEN tmpInputFile FOR OUTPUT AS #1
    PRINT #1, "{"
    PRINT #1, "  ""contents"": ["
    PRINT #1, "    {""role"": ""user"", ""parts"": [{""text"": """ + prompt$ + """}]}"
    PRINT #1, "  ]"
    PRINT #1, "}"
    CLOSE #1

    ' cURL command to call Gemini API
    command
