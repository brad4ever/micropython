# This file is part of the MicroPython project, http://micropython.org/
# The MIT License (MIT)
# Copyright (c) 2022-2023 Damien P. George
#
# This file is intended to be included by a Makefile in a custom project.

# Set the build output directory for the generated files.
BUILD = build-embed

# Include the core environment definitions; this will set $(TOP).
include $(MICROPYTHON_TOP)/py/mkenv.mk

# Include py core make definitions.
include $(TOP)/py/py.mk

# Set the location of the MicroPython embed port.
MICROPYTHON_EMBED_PORT = $(MICROPYTHON_TOP)/ports/esp32_embed

# Set default makefile-level MicroPython feature configurations.
MICROPY_ROM_TEXT_COMPRESSION ?= 0

#------------------------------------------
IDF_PATH = esp-idf/components
ELF_PATH = esp-idf/elf/include
#INC += -imacros esp-idf/components/newlib/platform_include/endian.h  TODO SISTEAMRE -- è sotto elf
INC += -imacros esp-idf/components/newlib/platform_include/sys/reent.h
#INC += -imacros /root/esp/esp-idf/components/esp_driver_sdmmc/include/driver/sdmmc_host.h
INC += -I.
INC += -I$(IDF_PATH)/esp_pm/include
#INC += -I$(filter-out esp-idf/elf/include/sys/param.h,$(IDF_PATH)/esp_pm/include/sys) # Remove the default sys/param.h TODO SISTEMARE
INC += -I$(IDF_PATH)/driver/touch_sensor/esp32/include
INC += -I$(IDF_PATH)/driver/touch_sensor/include
INC += -I$(IDF_PATH)/hal/platform_port/include
INC += -I$(IDF_PATH)/soc/include
INC += -I$(IDF_PATH)/log/include
INC += -I$(IDF_PATH)/esp_driver_spi/include
INC += -I$(IDF_PATH)/esp_driver_sdspi/include
INC += -I$(IDF_PATH)/hal/include
INC += -I$(IDF_PATH)/hal/esp32/include
INC += -I$(IDF_PATH)/esp_driver_gpio/include
INC += -I$(IDF_PATH)/esp_hw_support/dma/include
INC += -I$(IDF_PATH)/newlib/platform_include/sys
INC += -I$(IDF_PATH)/esp_rom/include
INC += -I$(IDF_PATH)/heap/include
INC += -I$(IDF_PATH)/esp_system/include
INC += -I$(IDF_PATH)/soc/esp32s3/include
INC += -I$(IDF_PATH)/riscv/include
INC += -I$(IDF_PATH)/esp_hw_support/include
INC += -I$(IDF_PATH)/freertos/FreeRTOS-Kernel/portable/xtensa/include/freertos
INC += -I$(IDF_PATH)/newlib/platform_include
INC += -I$(IDF_PATH)/xtensa/esp32/include
INC += -I$(IDF_PATH)/xtensa/include
INC += -I$(IDF_PATH)/freertos/config/xtensa/include
INC += -I$(IDF_PATH)/freertos/config/include/freertos
INC += -I$(IDF_PATH)/freertos/FreeRTOS-Kernel/include
INC += -I$(IDF_PATH)/sdmmc/include
INC += -I$(IDF_PATH)/esp_common/include
INC += -I$(IDF_PATH)/soc/esp32/include
INC += -I$(IDF_PATH)/esp_driver_sdmmc/include
INC += -I$(ELF_PATH)
#CFLAGS += -DSOC_CAPS_ECO_VER=301 $(INC)
CFLAGS += $(INC)
#CFLAGS += -DMICROPY_PY_MACHINE=1
CFLAGS_EXTRA='-DMP_CONFIGFILE="<mpconfigport.h>"
#------------------------------------------

# Set CFLAGS for the MicroPython build.
CFLAGS += -I. -I$(TOP) -I$(BUILD) -I$(MICROPYTHON_EMBED_PORT)
#CFLAGS += -DFFCONF_H=\"ports/esp32_embed/micropython_embed/lib/oofatfs/ffconf.h\"
CFLAGS += -Wall -Werror -std=c99

# Define the required generated header files.
GENHDR_OUTPUT = $(addprefix $(BUILD)/genhdr/, \
	moduledefs.h \
	mpversion.h \
	qstrdefs.generated.h \
	root_pointers.h \
	)

SHARED_SRC_C += $(addprefix shared/,\
	readline/readline.c \
	timeutils/timeutils.c \
	)	

EXTMOD_SRC_C += $(addprefix extmod/,\
	modos.c \
	modvfs.c \
	modmachine.c \
	machine_mem.c \
	machine_signal.c \
	machine_spi.c \
	vfs.c \
	vfs_blockdev.c \
	vfs_fat.c \
	vfs_lfs.c \
	vfs_reader.c \
	vfs_lfsx.c \
	vfs_lfsx_file.c \
	)	

LIB_SRC_C += $(addprefix lib/,\
	littlefs/lfs2.c \
	littlefs/lfs2_util.c \
	)

CUST_SRC_C += $(addprefix ports/esp32_embed/,\
	esp32_partition.c \
	modesp32.c \
	modmachine.c \
	machine_rtc.c \
	machine_hw_spi.c \
	machine_pin.c \
	pins.c \
	machine_timer.c \
	machine_touchpad.c \
	embed_util.c \
	machine_sdcard.c \
	)		
# List of sources for qstr extraction
SRC_QSTR += $(SHARED_SRC_C) $(EXTMOD_SRC_C) $(LIB_SRC_C) $(CUST_SRC_C)

# Define the top-level target, the generated output files.
.PHONY: all
all: micropython-embed-package

clean: clean-micropython-embed-package

.PHONY: clean-micropython-embed-package
clean-micropython-embed-package:
	$(RM) -rf $(PACKAGE_DIR)

PACKAGE_DIR ?= micropython_embed
PACKAGE_DIR_LIST = $(addprefix $(PACKAGE_DIR)/,py extmod shared/runtime genhdr port shared/readline shared/timeutils lib/littlefs lib/oofatfs idf drivers/bus)

.PHONY: micropython-embed-package
micropython-embed-package: $(GENHDR_OUTPUT)
	$(ECHO) "Generate micropython_embed output:"
	$(Q)$(RM) -rf $(PACKAGE_DIR_LIST)
	$(Q)$(MKDIR) -p $(PACKAGE_DIR_LIST)
	$(ECHO) "- py"
	$(Q)$(CP) $(TOP)/py/*.[ch] $(PACKAGE_DIR)/py
	$(ECHO) "- bus"
	$(Q)$(CP) $(TOP)/drivers/bus/spi.h $(PACKAGE_DIR)/drivers/bus
	$(Q)$(CP) $(TOP)/drivers/bus/softspi.c $(PACKAGE_DIR)/drivers/bus
	$(ECHO) "- extmod"
	$(Q)$(CP) $(TOP)/extmod/modplatform.h $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/modos.c $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/misc.h $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/modvfs.c $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/modmachine.h $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/modmachine.c $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/machine_mem.c $(PACKAGE_DIR)/extmod		
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/machine_signal.c $(PACKAGE_DIR)/extmod		
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/machine_spi.c $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/virtpin.h $(PACKAGE_DIR)/extmod		
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/virtpin.c $(PACKAGE_DIR)/extmod		
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs.h $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs.c $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_blockdev.c $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_lfs.h $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_lfs.c $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_reader.c $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_fat.h $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_fat.c $(PACKAGE_DIR)/extmod		
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_lfsx.c $(PACKAGE_DIR)/extmod				
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_lfsx_file.c $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/vfs_posix.h $(PACKAGE_DIR)/extmod		
	$(ECHO) "- lib"
	$(Q)$(CP) $(MICROPYTHON_TOP)/lib/littlefs/lfs2.h $(PACKAGE_DIR)/lib/littlefs
	$(Q)$(CP) $(MICROPYTHON_TOP)/lib/littlefs/lfs2.c $(PACKAGE_DIR)/lib/littlefs
	$(Q)$(CP) $(MICROPYTHON_TOP)/lib/littlefs/lfs2_util.h $(PACKAGE_DIR)/lib/littlefs
	$(Q)$(CP) $(MICROPYTHON_TOP)/lib/littlefs/lfs2_util.c $(PACKAGE_DIR)/lib/littlefs
	$(Q)$(CP) $(MICROPYTHON_TOP)/lib/oofatfs/diskio.h $(PACKAGE_DIR)/lib/oofatfs
	$(Q)$(CP) $(MICROPYTHON_TOP)/lib/oofatfs/ff.c $(PACKAGE_DIR)/lib/oofatfs
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/ff.h $(PACKAGE_DIR)/lib/oofatfs
	$(Q)$(CP) $(MICROPYTHON_TOP)/lib/oofatfs/ffconf.h $(PACKAGE_DIR)/lib/oofatfs
	$(Q)$(CP) $(MICROPYTHON_TOP)/lib/oofatfs/ffunicode.c $(PACKAGE_DIR)/lib/oofatfs
	$(ECHO) "- shared"
	$(Q)$(CP) $(TOP)/shared/runtime/gchelper.h $(PACKAGE_DIR)/shared/runtime
	$(Q)$(CP) $(TOP)/shared/runtime/gchelper_generic.c $(PACKAGE_DIR)/shared/runtime
	$(Q)$(CP) $(TOP)/shared/runtime/pyexec.c $(PACKAGE_DIR)/shared/runtime
	$(Q)$(CP) $(TOP)/shared/runtime/pyexec.h $(PACKAGE_DIR)/shared/runtime	
	$(Q)$(CP) $(TOP)/shared/runtime/interrupt_char.c $(PACKAGE_DIR)/shared/runtime
	$(Q)$(CP) $(TOP)/shared/runtime/interrupt_char.h $(PACKAGE_DIR)/shared/runtime	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/readline.c $(PACKAGE_DIR)/shared/readline
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/readline.h $(PACKAGE_DIR)/shared/readline
	$(Q)$(CP) $(MICROPYTHON_TOP)/shared/timeutils/timeutils.c $(PACKAGE_DIR)/shared/timeutils			
	$(Q)$(CP) $(MICROPYTHON_TOP)/shared/timeutils/timeutils.h $(PACKAGE_DIR)/shared/timeutils		
	$(ECHO) "- genhdr"
	$(Q)$(CP) $(GENHDR_OUTPUT) $(PACKAGE_DIR)/genhdr
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/genhdr/pins.h $(PACKAGE_DIR)/genhdr
	$(ECHO) "- port"
	$(Q)$(CP) $(MICROPYTHON_EMBED_PORT)/port/*.[ch] $(PACKAGE_DIR)/port
#	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/mphalport.h $(PACKAGE_DIR)/port/
#	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/mphalport.c $(PACKAGE_DIR)/port/	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/esp32_partition.c $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/modesp32.h $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/modesp32.c $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/machine_rtc.c $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/machine_rtc.h $(PACKAGE_DIR)/port		
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/modmachine.h $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/modmachine.c $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/machine_hw_spi.c $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/machine_pin.h $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/machine_pin.c $(PACKAGE_DIR)/port						
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/embed_util.c $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/micropython_embed.h $(PACKAGE_DIR)/port
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/machine_sdcard.c $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/pins.c $(PACKAGE_DIR)/port		
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/machine_timer.c $(PACKAGE_DIR)/port		
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/machine_touchpad.c $(PACKAGE_DIR)/port		
# https://github.com/espressif/esp-idf/blob/master/components/heap/multi_heap_platform.h custom port because not in clude in arduino framework	
	$(ECHO) "- idf"  
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/idf/heap_private.h $(PACKAGE_DIR)/idf
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/idf/multi_heap_platform.h $(PACKAGE_DIR)/idf
	


# Include remaining core make rules.
include $(TOP)/py/mkrules.mk
