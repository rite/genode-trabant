
#include <libc/component.h>
#include <os/static_root.h>
#include <log_session/log_session.h>
#include <timer_session/connection.h>
#include <curl/curl.h>
#include <libc/component.h>

extern "C" void client__login (char *user, int ulength, char *pass, int plength);

void Libc::Component::construct(Libc::Env &env)
{
    char user[] = "amatrix";
    char pass[] = "password";

    Timer::Connection timer(env);

    timer.msleep(4000);

    Libc::with_libc([&] () {
        curl_global_init(CURL_GLOBAL_DEFAULT);
        client__login(user, Genode::strlen(user), pass, Genode::strlen(pass));
        curl_global_cleanup();
    });
    env.parent().exit(0);
}
