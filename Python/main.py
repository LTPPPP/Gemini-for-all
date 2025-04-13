import openai
from utils import load_config

def main():
    api_key, model = load_config()
    openai.api_key = api_key
    openai.api_base = "https://generativelanguage.googleapis.com/v1beta"

    print("Welcome to the Gemini Chatbot! Type 'exit' to quit.\n")

    while True:
        user_input = input("You: ")
        if user_input.lower() == "exit":
            break

        try:
            response = openai.ChatCompletion.create(
                model=model,
                messages=[
                    {"role": "system", "content": "You are a helpful assistant."},
                    {"role": "user", "content": user_input}
                ]
            )
            print("Gemini:", response['choices'][0]['message']['content'])
        except Exception as e:
            print("Error:", str(e))

if __name__ == "__main__":
    main()
