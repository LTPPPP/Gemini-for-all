import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dotenv/dotenv.dart' as dotenv;

void main() async {
  dotenv.load(); // Load .env file

  final apiKey = dotenv.env['GEMINI_API_KEY'];
  final model = dotenv.env['MODEL'];

  if (apiKey == null || model == null) {
    print('Missing GEMINI_API_KEY or MODEL in .env');
    return;
  }

  final userInput = "Hello, who are you?";

  final response = await chatWithGemini(userInput, apiKey, model);

  print("Gemini: $response");
}

Future<String> chatWithGemini(String input, String apiKey, String model) async {
  final url = Uri.parse(
    "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey",
  );

  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({
    "contents": [
      {
        "parts": [
          {"text": input}
        ]
      }
    ]
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final reply = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
    return reply ?? "No response";
  } else {
    return "Error: ${response.statusCode} ${response.body}";
  }
}
