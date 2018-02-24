
#include <base/component.h>
#include <base/log.h>

void Component::construct(Genode::Env &)
{
    Genode::log("log");
    Genode::warning("warning");
    Genode::error("error");
    Genode::log("log");
}
