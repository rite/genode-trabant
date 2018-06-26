TARGET = matrix_log
SRC_CC = main.cc gnat.cc
SRC_ADB = client.adb http.adb
LIBS = ada base amatrix jwx
INC_DIR += $(PRG_DIR)

vpath http.adb $(REP_DIR)/src/lib/amatrix
