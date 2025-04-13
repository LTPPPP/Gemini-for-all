#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
#include <map>
#include "http_client.hpp"

// Function to read .env file
std::map<std::string, std::string> load_env(const std::string &filename)
{
    std::ifstream file(filename);
    std::map<std::string, std::string> env;
    std::string line;
    while (std::getline(file, line))
    {
        size_t eq = line.find('=');
        if (eq != std::string::npos)
        {
            std::string key = line.substr(0, eq);
            std::string value = line.substr(eq + 1);
            env[key] = value;
        }
    }
    return env;
}

int main()
{
    auto env = load_env(".env");
    std::string api_key = env["GEMINI_API_KEY"];
    std::string model = env["MODEL"];

    std::string input;
    std::cout << "🤖 Gemini Chatbot (type 'exit' to quit)\n";
    while (true)
    {
        std::cout << "\nYou: ";
        std::getline(std::cin, input);
        if (input == "exit")
            break;
        std::string response = send_gemini_request(api_key, model, input);
        std::cout << "Gemini: " << response << std::endl;
    }
    return 0;
}
