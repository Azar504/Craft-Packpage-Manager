CC=clang
CFLAGS=-O3 -march=armv8-a -flto
BUILD=build
TARGET=bin/craft_core

all: dirs core

dirs:
	mkdir -p $(BUILD) bin

core: src/craft_core.c | dirs
	$(CC) $(CFLAGS) $< -o $(TARGET)

clean:
	rm -rf $(BUILD) bin
