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
MICROPYTHON_EMBED_PORT = $(MICROPYTHON_TOP)/ports/embed

# Set default makefile-level MicroPython feature configurations.
MICROPY_ROM_TEXT_COMPRESSION ?= 0

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
	embed_util.c \
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
PACKAGE_DIR_LIST = $(addprefix $(PACKAGE_DIR)/,py extmod shared/runtime genhdr port shared/readline shared/timeutils lib/littlefs lib/oofatfs idf)

.PHONY: micropython-embed-package
micropython-embed-package: $(GENHDR_OUTPUT)
	$(ECHO) "Generate micropython_embed output:"
	$(Q)$(RM) -rf $(PACKAGE_DIR_LIST)
	$(Q)$(MKDIR) -p $(PACKAGE_DIR_LIST)
	$(ECHO) "- py"
	$(Q)$(CP) $(TOP)/py/*.[ch] $(PACKAGE_DIR)/py
	$(ECHO) "- extmod"
	$(Q)$(CP) $(TOP)/extmod/modplatform.h $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/modos.c $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/misc.h $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/modvfs.c $(PACKAGE_DIR)/extmod
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
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/readline.c $(PACKAGE_DIR)/shared/readline
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/readline.h $(PACKAGE_DIR)/shared/readline
	$(Q)$(CP) $(MICROPYTHON_TOP)/shared/timeutils/timeutils.h $(PACKAGE_DIR)/shared/timeutils		
	$(ECHO) "- genhdr"
	$(Q)$(CP) $(GENHDR_OUTPUT) $(PACKAGE_DIR)/genhdr
	$(ECHO) "- port"
	$(Q)$(CP) $(MICROPYTHON_EMBED_PORT)/port/*.[ch] $(PACKAGE_DIR)/port
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/mphalport.h $(PACKAGE_DIR)/port/
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/mphalport.c $(PACKAGE_DIR)/port/	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/esp32_partition.c $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/modesp32.h $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/modesp32.c $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/embed_util.c $(PACKAGE_DIR)/port	
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/micropython_embed.h $(PACKAGE_DIR)/port
# https://github.com/espressif/esp-idf/blob/master/components/heap/multi_heap_platform.h custom port because not in clude in arduino framework	
	$(ECHO) "- idf"  
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/heap_private.h $(PACKAGE_DIR)/idf
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/multi_heap_platform.h $(PACKAGE_DIR)/idf
	


# Include remaining core make rules.
include $(TOP)/py/mkrules.mk
