       IDENTIFICATION DIVISION.
       PROGRAM-ID. ChatBotGemini.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT InputFile ASSIGN TO "input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OutputFile ASSIGN TO "output.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD InputFile.
       01 UserInput PIC X(200).
       
       FD OutputFile.
       01 BotResponse PIC X(1000).

       WORKING-STORAGE SECTION.
       01 UserPrompt PIC X(200).
       01 Command     PIC X(100) VALUE "sh ask_gemini.sh".
       01 WS-STATUS   PIC 9(03) COMP.

       PROCEDURE DIVISION.
       BEGIN.
           DISPLAY "Enter your message to Gemini:".
           ACCEPT UserPrompt.

           OPEN OUTPUT InputFile.
           WRITE UserInput FROM UserPrompt.
           CLOSE InputFile.

           CALL 'SYSTEM' USING Command.

           OPEN INPUT OutputFile.
           READ OutputFile INTO BotResponse
               AT END DISPLAY "No response from Gemini."
               NOT AT END DISPLAY "Gemini: " BotResponse
           END-READ.
           CLOSE OutputFile.

           STOP RUN.
