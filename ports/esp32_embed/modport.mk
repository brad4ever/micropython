MICROPYTHON_TOP = ../..

PACKAGE_DIR_LIST_CUSTOM = $(addprefix $(PACKAGE_DIR)/,shared/readline shared/timeutils)

# Custom commands
.PHONY: modport 
modport:
	$(info Custom command: Copying readline files...)
	$(Q)$(RM) -rf $(PACKAGE_DIR_LIST_CUSTOM)
	$(Q)$(MKDIR) -p $(PACKAGE_DIR_LIST_CUSTOM)
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/mphalport.h $(PACKAGE_DIR)/port/
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/mphalport.c $(PACKAGE_DIR)/port/
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/readline.c $(PACKAGE_DIR)/shared/readline
	$(Q)$(CP) $(MICROPYTHON_TOP)/ports/esp32_embed/readline.h $(PACKAGE_DIR)/shared/readline
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs.h $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs.c $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_blockdev.c $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_lfs.h $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_lfs.c $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_reader.c $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_fat.h $(PACKAGE_DIR)/extmod
	$(Q)$(CP) $(MICROPYTHON_TOP)/extmod/vfs_fat.c $(PACKAGE_DIR)/extmod	
	$(Q)$(CP) $(MICROPYTHON_TOP)/shared/timeutils/timeutils.h $(PACKAGE_DIR)/shared/timeutils
