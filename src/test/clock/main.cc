
#include <libc/component.h>
#include <base/component.h>
#include <rtc_session/connection.h>
#include <timer_session/connection.h>
#include <base/attached_rom_dataspace.h>
#include <util/xml_node.h>

#include <time.h>

struct Main
{
    Genode::Env &_env;

    Timer::Connection _timer;

    Rtc::Connection _x86;
    Rtc::Connection _sntp;
    Rtc::Connection _clock;

    Genode::Attached_rom_dataspace _config { _env, "config" };

    time_t convert(Rtc::Timestamp ts)
    {
        time_t time;
        struct tm stm;
        
        Genode::memset(&stm, 0, sizeof(struct tm));
        stm.tm_sec = ts.second;
        stm.tm_min = ts.minute;
        stm.tm_hour = ts.hour;
        stm.tm_mday = ts.day;
        stm.tm_mon = ts.month - 1;
        stm.tm_year = ts.year - 1900;

        Libc::with_libc([&] (){
                time = mktime(&stm);
                });

        return time;
    }

    Rtc::Timestamp convert(time_t ts)
    {
        Rtc::Timestamp rts;
        struct tm *stm;
        Libc::with_libc([&] (){
                stm = gmtime(&ts);

                rts.second = stm->tm_sec;
                rts.minute = stm->tm_min;
                rts.hour = stm->tm_hour;
                rts.day = stm->tm_mday;
                rts.month = stm->tm_mon + 1;
                rts.year = stm->tm_year + 1900;
                });

        return rts;
    }

    void print_time(Genode::String<64> label, Rtc::Timestamp ts)
    {
        Genode::log(label, " : ",
            ts.year, "-",ts.month, "-",ts.day, " ",
            ts.hour, ":",ts.minute, ":",ts.second, " ",
                convert(ts));
    }

    Main(Genode::Env &env) : _env(env), _timer(env), _x86(env, "x86"), _sntp(env, "sntp"), _clock(env, "clock")
    {
        unsigned long timeout = _config.xml().attribute_value<unsigned long>("timeout", 3);
        unsigned long step = 20;
        Genode::log("--- clock test (", timeout, " times, ", step, "s) ---");
            
        Genode::log("test 1 : ");
        print_time(Genode::Cstring("X86"), _x86.current_time());
        print_time(Genode::Cstring("Sntp"), _sntp.current_time());
        print_time(Genode::Cstring("clock"), _clock.current_time());

        for(unsigned long i = 1; i < timeout; i++){
            _timer.msleep(step * 1000);
            Genode::log("test ", i + 1, " : ");
            print_time(Genode::Cstring("X86"), _x86.current_time());
            print_time(Genode::Cstring("Sntp"), _sntp.current_time());
            print_time(Genode::Cstring("clock"), _clock.current_time());
        }

        Genode::log("--- clock test finished ---");
    }
};

void Libc::Component::construct(Libc::Env &env)
{
    static Main main(env);
}
