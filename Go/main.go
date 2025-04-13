package main

import (
	"fmt"
	"log"

	"go-gemini-chatbot/utils"

	"github.com/go-resty/resty/v2"
)

type GeminiRequest struct {
	Contents []Content `json:"contents"`
}

type Content struct {
	Parts []Part `json:"parts"`
	Role  string `json:"role"`
}

type Part struct {
	Text string `json:"text"`
}

type GeminiResponse struct {
	Candidates []struct {
		Content Content `json:"content"`
	} `json:"candidates"`
}

func main() {
	utils.LoadEnv()

	apiKey := utils.GetEnv("GEMINI_API_KEY")
	model := utils.GetEnv("MODEL")
	if apiKey == "" || model == "" {
		log.Fatal("Missing GEMINI_API_KEY or MODEL in .env")
	}

	client := resty.New()

	for {
		var userInput string
		fmt.Print("You: ")
		fmt.Scanln(&userInput)

		if userInput == "exit" {
			break
		}

		reqBody := GeminiRequest{
			Contents: []Content{
				{
					Role: "user",
					Parts: []Part{
						{Text: userInput},
					},
				},
			},
		}

		var geminiResp GeminiResponse
		resp, err := client.R().
			SetHeader("Content-Type", "application/json").
			SetHeader("Authorization", "Bearer "+apiKey).
			SetBody(reqBody).
			SetResult(&geminiResp).
			Post("https://generativelanguage.googleapis.com/v1beta/models/" + model + ":generateContent")

		if err != nil || !resp.IsSuccess() {
			log.Fatalf("API request failed: %v\n", err)
		}

		if len(geminiResp.Candidates) > 0 {
			fmt.Println("Gemini:", geminiResp.Candidates[0].Content.Parts[0].Text)
		} else {
			fmt.Println("Gemini: (No response)")
		}
	}
}
