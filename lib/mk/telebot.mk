TELEBOT_DIR := $(call select_from_ports,telebot)/src/lib/telebot

include $(REP_DIR)/lib/import/import-telebot.mk

SRC_C = telebot.c \
	telebot-core.c \
	telebot-parser.c

vpath %.c $(TELEBOT_DIR)/src

INC_DIR += $(TELEBOT_DIR)
INC_DIR += $(TELEBOT_DIR)/include

LIBS += libc curl jsonc
