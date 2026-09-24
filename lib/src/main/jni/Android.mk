LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_MODULE:= libandroid_spatialite

LOCAL_STATIC_LIBRARIES := \
    spatialite

LOCAL_SRC_FILES:= \
    android_database_SQLiteCommon.cpp \
    android_database_SQLiteConnection.cpp \
    android_database_SQLiteGlobal.cpp \
    android_database_SQLiteDebug.cpp \
    android_database_CursorWindow.cpp \
    CursorWindow.cpp \
    JNIHelp.cpp \
    JNIString.cpp

ifeq ($(TARGET_ARCH), arm)
    LOCAL_CFLAGS += -DPACKED="__attribute__ ((packed))"
else
    LOCAL_CFLAGS += -DPACKED=""
endif

LOCAL_CFLAGS += -Wno-unused-parameter -Wno-int-to-pointer-cast
LOCAL_CFLAGS += -Wno-uninitialized -Wno-parentheses -Wpointer-bool-conversion
LOCAL_CPPFLAGS += -Wno-conversion-null

# libs from the NDK
LOCAL_LDLIBS += -llog

include $(BUILD_SHARED_LIBRARY)

# The library concrete version subfolder name must match its .mk file.
# E.g. libxml2-2.9.2/ -> libxml2-2.9.2.mk

NDK_MODULES_PATH := $(LOCAL_PATH)/ndk-modules

SPATIALITE_PATH := libspatialite
PROJ4_PATH := proj
GEOS_PATH := geos
ICONV_PATH := libiconv
XML2_PATH := libxml2
FREEXL_PATH := freexl
LWGEOM_PATH := liblwgeom

include $(NDK_MODULES_PATH)/sqlite/sqlite.mk
include $(NDK_MODULES_PATH)/libspatialite/$(SPATIALITE_PATH).mk
include $(NDK_MODULES_PATH)/proj.4/$(PROJ4_PATH).mk
include $(NDK_MODULES_PATH)/geos/$(GEOS_PATH).mk
include $(NDK_MODULES_PATH)/libiconv/$(ICONV_PATH).mk
include $(NDK_MODULES_PATH)/libxml2/$(XML2_PATH).mk
include $(NDK_MODULES_PATH)/freexl/$(FREEXL_PATH).mk
include $(NDK_MODULES_PATH)/liblwgeom/$(LWGEOM_PATH).mk

# NOTE: iconv is dependency of Spatialite virtual modules like VirtualText, VirtualShape, VirtualXL, etc.
