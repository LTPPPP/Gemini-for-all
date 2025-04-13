import os
from dotenv import load_dotenv

def load_config():
    load_dotenv()
    api_key = os.getenv("GEMINI_API_KEY")
    model = os.getenv("MODEL")

    if not api_key or not model:
        raise ValueError("Missing GEMINI_API_KEY or MODEL in .env")

    return api_key, model
