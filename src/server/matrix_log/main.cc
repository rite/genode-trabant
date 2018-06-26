
#include <libc/component.h>
#include <os/static_root.h>
#include <log_session/log_session.h>

extern "C" void client__login (char *user, int ulength, char *pass, int plength);

void Libc::Component::construct(Libc::Env &env)
{
    char user[] = "a";
    char pass[] = "b";

    client__login(user, 1, pass, 1);
    env.parent().exit(0);
}
