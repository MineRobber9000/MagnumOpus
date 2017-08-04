SOURCES := src/bootstrap.lua src/main.lua

all: $(SOURCES)
	cat $(SOURCES) > magnumopus.lua
