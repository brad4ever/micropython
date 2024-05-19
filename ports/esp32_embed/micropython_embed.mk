# This file is part of the MicroPython project, http://micropython.org/
# The MIT License (MIT)
# Copyright (c) 2022-2023 Damien P. George

# Set the location of the top of the MicroPython repository.
MICROPYTHON_TOP = ../..

# Include the main makefile fragment to build the MicroPython component.
#include $(MICROPYTHON_TOP)/ports/embed/embed.mk
include $(MICROPYTHON_TOP)/ports/esp32_embed/embed.mk

# Include the custom commands
#include modport.mk
#all: modport
