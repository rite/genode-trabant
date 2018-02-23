
#include <libc/component.h>
#include <base/component.h>
#include <base/log.h>
#include <base/heap.h>
#include <root/component.h>
#include <rtc_session/rtc_session.h>
#include <timer_session/connection.h>
#include <util/xml_node.h>

#include <time.h>

#include <clock.h>

namespace Clock {
    struct Session_component;
    struct Root;
    struct Main;
};

struct Clock::Session_component : public Genode::Rpc_object<Rtc::Session>
{
    Genode::Env &_env;

    Clock &_clock;

    Session_component(Genode::Env &env, Clock &clock) :
        _env(env), _clock(clock)
    { }

    Rtc::Timestamp current_time()
    {
        return _clock.gettime();
    }
};

struct Clock::Root : public Genode::Root_component<Session_component>
{
    private:

        Genode::Env &_env;

        Clock &_clock;

    protected:

        Session_component *_create_session(const char *)
        {
            return new (md_alloc()) Session_component(_env, _clock);
        }

    public:

        Root(Genode::Env &env, Genode::Allocator &md_alloc, Clock &clock) :
            Genode::Root_component<Session_component>(&env.ep().rpc_ep(), &md_alloc),
            _env(env), _clock(clock)
    { }
};

struct Clock::Main
{
    Genode::Env &_env;

    Genode::Sliced_heap _sheap { _env.ram(), _env.rm() };

    Clock _clock { _env };

    Root _root { _env, _sheap, _clock };

    Main(Genode::Env &env) : _env(env)
    {
        Genode::log("---clock---");
        _env.parent().announce(_env.ep().manage(_root));
    }
};

void Libc::Component::construct(Libc::Env &env)
{
    static Clock::Main main(env);
}
