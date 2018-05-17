
#include <base/log.h>
#include <util/string.h>
#include <curl/curl.h>

struct lv_string {
    int length;
    char *value;
};

static char postbuffer[8192];
static struct lv_string lvs;

static Genode::size_t recv_callback (char *ptr, Genode::size_t size, Genode::size_t nmemb, char *data)
{
    Genode::log(__func__, " ", size, " ", nmemb, " ", Genode::Cstring(data));
    Genode::memcpy(postbuffer, ptr, size * nmemb);
    lvs.length = size * nmemb;
    lvs.value = postbuffer;
    return size * nmemb;
}

extern "C" {

    struct lv_string *curl_post(CURL *curl, char *url, char *data)
    {
        Genode::memset(postbuffer, 0, 8192);
        curl_easy_setopt(curl, CURLOPT_URL, url);
        curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
        curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, recv_callback);
        curl_easy_perform(curl);
        return &lvs;
    }

}
