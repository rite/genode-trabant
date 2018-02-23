
#ifndef _CLOCK_H_
#define _CLOCK_H_

#include <timer_session/connection.h>
#include <rtc_session/connection.h>

namespace Clock {
    class Clock;
    enum {
        SYNC_TIMEOUT = 3600000000
    };
};

class Clock::Clock
{
    private:

        Rtc::Timestamp _synced_timestamp;
        unsigned long _local_timestamp;
        long _skew;
        int _skew_status;
        unsigned _skew_periods;

        Timer::Connection _timer;
        Genode::Signal_handler<Clock> _sync_sigh;
        Rtc::Connection _rtc;

        void synchronize();
        unsigned long convert(Rtc::Timestamp);
        Rtc::Timestamp convert(unsigned long);

    public:

        Clock(Genode::Env &);
        Rtc::Timestamp gettime();
};

#endif /* ifndef _CLOCK_H_ */
