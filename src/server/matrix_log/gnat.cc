
#include <base/log.h>

extern "C" {

    void system__soft_links__abort_undefer()
    {
        Genode::error(__func__, " not implemented");
    }

    void __gnat_raise_from_controlled_operation()
    {
        Genode::error(__func__, " not implemented");
    }

    void __gnat_raise_nodefer_with_msg()
    {
        Genode::error(__func__, " not implemented");
    }


}
