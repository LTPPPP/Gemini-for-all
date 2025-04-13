#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <curl/curl.h>

char *get_env_value(const char *key)
{
    FILE *file = fopen(".env", "r");
    if (!file)
        return NULL;

    static char line[256];
    while (fgets(line, sizeof(line), file))
    {
        if (strncmp(line, key, strlen(key)) == 0)
        {
            fclose(file);
            return strtok(line + strlen(key) + 1, "\n");
        }
    }
    fclose(file);
    return NULL;
}

size_t write_callback(void *ptr, size_t size, size_t nmemb, char *data)
{
    fwrite(ptr, size, nmemb, stdout);
    return size * nmemb;
}

void make_gemini_request(char *prompt)
{
    CURL *curl = curl_easy_init();
    if (!curl)
        return;

    const char *api_key = get_env_value("GEMINI_API_KEY");
    const char *model = get_env_value("MODEL");

    if (!api_key || !model)
    {
        fprintf(stderr, "Missing .env variables\n");
        return;
    }

    char url[256];
    snprintf(url, sizeof(url), "https://generativelanguage.googleapis.com/v1beta/models/%s:generateContent?key=%s", model, api_key);

    char post_data[1024];
    snprintf(post_data, sizeof(post_data),
             "{\"contents\": [{\"parts\": [{\"text\": \"%s\"}]}]}",
             prompt);

    struct curl_slist *headers = NULL;
    headers = curl_slist_append(headers, "Content-Type: application/json");

    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
    curl_easy_setopt(curl, CURLOPT_POSTFIELDS, post_data);
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, write_callback);

    curl_easy_perform(curl);
    curl_easy_cleanup(curl);
}
