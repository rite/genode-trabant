
include $(REP_DIR)/lib/import/import-amatrix.mk

INC_DIR += $(REP_DIR)/src/lib/amatrix

SRC_ADB = amatrix-client.adb \
	  http.adb

vpath http.adb $(REP_DIR)/src/lib/amatrix
vpath %.adb $(AMATRIX_DIR)

LIBS += ada jwx
