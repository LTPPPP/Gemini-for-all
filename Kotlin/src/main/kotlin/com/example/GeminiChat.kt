package com.example

import io.github.cdimascio.dotenv.dotenv
import okhttp3.*
import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue

fun main() {
    val dotenv = dotenv()
    val apiKey = dotenv["GEMINI_API_KEY"]
    val model = dotenv["MODEL"] ?: "gemini-2.0-flash"

    val userInput = "Hello, Gemini! Can you help me write Kotlin code?"

    val response = chatWithGemini(apiKey, model, userInput)
    println("Response from Gemini:\n$response")
}

fun chatWithGemini(apiKey: String, model: String, prompt: String): String {
    val client = OkHttpClient()
    val url = "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey"

    val json = """
        {
            "contents": [
                {
                    "parts": [
                        {
                            "text": "$prompt"
                        }
                    ]
                }
            ]
        }
    """.trimIndent()

    val body = RequestBody.create(MediaType.parse("application/json; charset=utf-8"), json)

    val request = Request.Builder()
        .url(url)
        .post(body)
        .build()

    client.newCall(request).execute().use { response ->
        if (!response.isSuccessful) {
            return "Error: ${response.code()} - ${response.body()?.string()}"
        }

        val mapper = jacksonObjectMapper()
        val jsonTree = mapper.readTree(response.body()?.string())
        val content = jsonTree["candidates"]?.get(0)?["content"]?.get("parts")?.get(0)?.get("text")?.asText()
        return content ?: "No content received."
    }
}
