TARGET   = vga_log_drv
LIBS     = base
SRC_CC   = main.cc
SRC_ADA  = vga.adb escape_dfa.adb
INC_DIR += $(PRG_DIR)/include

include $(REP_DIR)/mk/gnat_opts.mk
