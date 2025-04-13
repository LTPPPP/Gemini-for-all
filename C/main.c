#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>
#include <json-c/json.h> // Requires the json-c library

// Callback to write server response into a string
static size_t WriteCallback(void *contents, size_t size, size_t nmemb, void *userp)
{
    size_t totalSize = size * nmemb;
    strncat(userp, contents, totalSize);
    return totalSize;
}

// Function to get API Key from .env file
char *get_api_key()
{
    FILE *file = fopen(".env", "r");
    if (!file)
    {
        perror("Unable to open .env file");
        exit(1);
    }

    static char key[256];
    while (fgets(key, sizeof(key), file))
    {
        if (strncmp(key, "GEMINI_API_KEY=", 15) == 0)
        {
            fclose(file);
            return key + 15;
        }
    }

    fclose(file);
    fprintf(stderr, "GEMINI_API_KEY not found in .env\n");
    exit(1);
}

void parse_and_print_response(const char *response)
{
    struct json_object *parsed_json, *contents, *text;
    parsed_json = json_tokener_parse(response);

    if (parsed_json == NULL)
    {
        fprintf(stderr, "Failed to parse JSON response\n");
        return;
    }

    if (json_object_object_get_ex(parsed_json, "contents", &contents))
    {
        if (json_object_array_length(contents) > 0)
        {
            struct json_object *first_content = json_object_array_get_idx(contents, 0);
            if (json_object_object_get_ex(first_content, "text", &text))
            {
                printf("Gemini: %s\n", json_object_get_string(text));
            }
        }
    }
    else
    {
        printf("Gemini: (No valid response)\n");
    }

    json_object_put(parsed_json); // Free memory
}

int main()
{
    char prompt[1024];
    char response[8192] = {0};
    char url[512] = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=";

    CURL *curl;
    CURLcode res;

    char *api_key = get_api_key();
    api_key[strcspn(api_key, "\r\n")] = 0; // Remove newline
    strncat(url, api_key, sizeof(url) - strlen(url) - 1);

    printf("🤖 Gemini Chatbot (type 'exit' to quit)\n");

    while (1)
    {
        printf("\nYou: ");
        fgets(prompt, sizeof(prompt), stdin);

        if (strncmp(prompt, "exit", 4) == 0)
            break;

        char postData[2048];
        snprintf(postData, sizeof(postData),
                 "{ \"contents\": [{ \"parts\": [{ \"text\": \"%s\" }] }] }", prompt);

        curl_global_init(CURL_GLOBAL_ALL);
        curl = curl_easy_init();

        if (curl)
        {
            struct curl_slist *headers = NULL;
            headers = curl_slist_append(headers, "Content-Type: application/json");

            curl_easy_setopt(curl, CURLOPT_URL, url);
            curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
            curl_easy_setopt(curl, CURLOPT_POSTFIELDS, postData);
            curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, WriteCallback);
            curl_easy_setopt(curl, CURLOPT_WRITEDATA, response);

            res = curl_easy_perform(curl);
            if (res != CURLE_OK)
            {
                fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
            }
            else
            {
                parse_and_print_response(response);
            }

            curl_easy_cleanup(curl);
            curl_global_cleanup();

            memset(response, 0, sizeof(response)); // Reset response buffer
        }
    }

    return 0;
}
