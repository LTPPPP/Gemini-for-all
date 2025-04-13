use dotenv::dotenv;
use reqwest::blocking::Client;
use serde::{Deserialize, Serialize};
use std::env;
use std::io::{self, Write};

#[derive(Serialize)]
struct GeminiRequest {
    contents: Vec<Content>,
}

#[derive(Serialize)]
struct Content {
    parts: Vec<Part>,
    role: String,
}

#[derive(Serialize)]
struct Part {
    text: String,
}

#[derive(Debug, Deserialize)]
struct GeminiResponse {
    candidates: Vec<Candidate>,
}

#[derive(Debug, Deserialize)]
struct Candidate {
    content: ContentOut,
}

#[derive(Debug, Deserialize)]
struct ContentOut {
    parts: Vec<PartOut>,
}

#[derive(Debug, Deserialize)]
struct PartOut {
    text: String,
}

fn main() {
    dotenv().ok();

    let api_key = env::var("GEMINI_API_KEY").expect("Missing GEMINI_API_KEY");
    let model = env::var("MODEL").unwrap_or_else(|_| "gemini-pro".to_string());

    let client = Client::new();
    let url = format!(
        "https://generativelanguage.googleapis.com/v1beta/models/{}:generateContent?key={}",
        model, api_key
    );

    println!("🧠 Gemini Chatbot (type 'exit' to quit)");
    loop {
        print!("You: ");
        io::stdout().flush().unwrap();

        let mut input = String::new();
        io::stdin().read_line(&mut input).unwrap();
        let input = input.trim();

        if input.eq_ignore_ascii_case("exit") {
            break;
        }

        let request = GeminiRequest {
            contents: vec![Content {
                role: "user".to_string(),
                parts: vec![Part {
                    text: input.to_string(),
                }],
            }],
        };

        let response = client
            .post(&url)
            .json(&request)
            .send()
            .expect("Failed to send request");

        if !response.status().is_success() {
            eprintln!("❌ Error: {}", response.status());
            continue;
        }

        let json: GeminiResponse = response
            .json()
            .expect("Failed to parse response");

        if let Some(text) = json
            .candidates
            .get(0)
            .and_then(|c| c.content.parts.get(0))
            .map(|p| &p.text)
        {
            println!("🤖 Gemini: {}", text);
        } else {
            println!("🤖 Gemini: (no response)");
        }
    }
}
