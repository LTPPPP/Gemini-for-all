#include "http_client.hpp"
#include <curl/curl.h>
#include <sstream>
#include <nlohmann/json.hpp>

using json = nlohmann::json;

size_t WriteCallback(void *contents, size_t size, size_t nmemb, void *userp)
{
    ((std::string *)userp)->append((char *)contents, size * nmemb);
    return size * nmemb;
}

std::string send_gemini_request(const std::string &api_key, const std::string &model, const std::string &user_input)
{
    CURL *curl = curl_easy_init();
    std::string readBuffer;

    if (curl)
    {
        std::string url = "https://generativelanguage.googleapis.com/v1beta/models/" + model + ":generateContent?key=" + api_key;

        json request_body = {
            {"contents", {{{"role", "user"}, {"parts", {{{"text", user_input}}}}}}}};

        std::string request_str = request_body.dump();

        struct curl_slist *headers = nullptr;
        headers = curl_slist_append(headers, "Content-Type: application/json");

        curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, request_str.c_str());
        curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
        curl_easy_setopt(curl, CURLOPT_WRITEDATA, &readBuffer);

        CURLcode res = curl_easy_perform(curl);
        curl_easy_cleanup(curl);
    }

    auto json_resp = json::parse(readBuffer);
    try
    {
        return json_resp["candidates"][0]["content"]["parts"][0]["text"];
    }
    catch (...)
    {
        return "Error response: " + readBuffer;
    }
}
