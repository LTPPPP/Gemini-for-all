using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.IO;

namespace GeminiChatbot
{
    class Program
    {
        static async Task Main(string[] args)
        {
            // Load environment variables
            var dotenv = new Dotenv.Dotenv();
            string apiKey = dotenv["GEMINI_API_KEY"];
            string model = dotenv["MODEL"];

            if (string.IsNullOrEmpty(apiKey) || string.IsNullOrEmpty(model))
            {
                Console.WriteLine("API key or model not set. Check your .env file.");
                return;
            }

            var chatbot = new GeminiChatbot(apiKey, model);

            Console.WriteLine("Welcome to the Gemini Chatbot!");
            while (true)
            {
                Console.Write("You: ");
                string userInput = Console.ReadLine();
                if (string.IsNullOrEmpty(userInput)) break;

                var response = await chatbot.GetChatbotResponseAsync(userInput);
                Console.WriteLine("Chatbot: " + response);
            }
        }
    }

    public class GeminiChatbot
    {
        private readonly string _apiKey;
        private readonly string _model;
        private readonly HttpClient _httpClient;

        public GeminiChatbot(string apiKey, string model)
        {
            _apiKey = apiKey;
            _model = model;
            _httpClient = new HttpClient();
        }

        public async Task<string> GetChatbotResponseAsync(string userInput)
        {
            var url = "https://api.google.com/generative-ai/v1/your-api-endpoint"; // Replace with the Gemini API endpoint.

            var requestBody = new
            {
                model = _model,
                messages = new[]
                {
                    new { role = "user", content = userInput }
                }
            };

            var jsonRequest = JsonConvert.SerializeObject(requestBody);
            var content = new StringContent(jsonRequest, Encoding.UTF8, "application/json");

            _httpClient.DefaultRequestHeaders.Add("Authorization", "Bearer " + _apiKey);

            try
            {
                var response = await _httpClient.PostAsync(url, content);
                response.EnsureSuccessStatusCode();
                string responseContent = await response.Content.ReadAsStringAsync();

                // Parse the response and extract the chatbot's reply
                var responseJson = JsonConvert.DeserializeObject<dynamic>(responseContent);
                string chatbotReply = responseJson.choices[0].message.content;

                return chatbotReply;
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }
    }
}
