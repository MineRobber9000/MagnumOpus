SOURCES := src/main.lua

all: $(SOURCES)
  cat $(SOURCES) > magnumopus.lua
