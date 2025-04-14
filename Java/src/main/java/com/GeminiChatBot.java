package com;

import java.io.IOException;
import java.util.Scanner;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import io.github.cdimascio.dotenv.Dotenv;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

public class GeminiChatBot {

    private static final Dotenv dotenv = Dotenv.load();
    private static final String API_KEY = dotenv.get("GEMINI_API_KEY");
    private static final String MODEL = dotenv.get("MODEL");
    private static final String ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/"
            + MODEL + ":generateContent?key=" + API_KEY;

    private static final OkHttpClient client = new OkHttpClient();
    private static final Gson gson = new Gson();

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        System.out.println("Gemini ChatBot 🤖 is running. Type 'exit' to quit.");

        while (true) {
            System.out.print("You: ");
            String input = scanner.nextLine();

            if ("exit".equalsIgnoreCase(input))
                break;

            try {
                String response = sendMessage(input);
                System.out.println("Gemini: " + response);
            } catch (IOException e) {
                System.err.println("Error communicating with Gemini API: " + e.getMessage());
            }
        }

        scanner.close();
    }

    private static String sendMessage(String userInput) throws IOException {
        JsonObject content = new JsonObject();
        JsonArray parts = new JsonArray();
        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", userInput);
        parts.add(textPart);
        JsonArray contentsArray = new JsonArray();
        JsonObject contentObject = new JsonObject();
        contentObject.add("parts", parts);
        contentsArray.add(contentObject);
        content.add("contents", contentsArray);

        RequestBody body = RequestBody.create(
                gson.toJson(content),
                MediaType.get("application/json"));

        Request request = new Request.Builder()
                .url(ENDPOINT)
                .post(body)
                .build();

        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                return "Failed: " + response.message();
            }

            String responseBody = response.body().string();
            JsonObject json = gson.fromJson(responseBody, JsonObject.class);
            JsonArray candidates = json.getAsJsonArray("candidates");
            if (candidates != null && candidates.size() > 0) {
                JsonObject first = candidates.get(0).getAsJsonObject();
                JsonObject message = first.getAsJsonObject("content");
                JsonArray msgParts = message.getAsJsonArray("parts");
                return msgParts.get(0).getAsJsonObject().get("text").getAsString();
            }

            return "No response from Gemini.";
        }
    }
}
