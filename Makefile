SOURCES := src/header.lua src/bootstrap.lua src/versioncheck.lua src/gui.lua src/main.lua

all: $(SOURCES)
	cat $(SOURCES) > magnumopus.lua
