
#include <libc/component.h>
#include <base/log.h>
#include <util/string.h>
#include <curl/curl.h>
#include <ada/exception.h>

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

    void __gnat_rcheck_PE_Missing_Return()
    {
        throw Ada::Exception::Program_Error();
    }

    struct lv_string *curl_post(char *url, char *data)
    {
        Genode::log(Genode::Cstring(url), ": ", Genode::Cstring(data));
        Genode::memset(postbuffer, 0, 8192);
        Libc::with_libc([&] () {
            CURL *curl = curl_easy_init();
            curl_easy_setopt(curl, CURLOPT_URL, url);
            curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
            curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, recv_callback);
            curl_easy_setopt(curl, CURLOPT_NOSIGNAL, true);
            Genode::log("perform: ", (int)curl_easy_perform(curl));
            curl_easy_cleanup(curl);
        });
        Genode::log(Genode::Cstring(postbuffer));
        return &lvs;
    }

    struct lv_string *curl_put(char *url, char *data, char *authentication)
    {
        Genode::log(Genode::Cstring(url), ": ", Genode::Cstring(data));
        Genode::log(Genode::Cstring(authentication));
        Genode::memset(postbuffer, 0, 8192);
        Libc::with_libc([&] () {
            struct curl_slist *headers = 0;
            headers = curl_slist_append(headers, authentication);
            CURL *curl = curl_easy_init();
            curl_easy_setopt(curl, CURLOPT_HTTPHEADER, headers);
            curl_easy_setopt(curl, CURLOPT_URL, url);
            curl_easy_setopt(curl, CURLOPT_CUSTOMREQUEST, "PUT");
            curl_easy_setopt(curl, CURLOPT_POSTFIELDS, data);
            curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, recv_callback);
            curl_easy_perform(curl);
            curl_slist_free_all(headers);
            curl_easy_cleanup(curl);
        });
        Genode::log(Genode::Cstring(postbuffer));
        return &lvs;
    }

}
