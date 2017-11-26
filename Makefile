ARCH		= arm
TARGET_ARCH	= $(ARCH)-none-eabihf
BUILD_ROOT	= build
SRC_ROOT	= src
KERNEL_ROOT = $(SRC_ROOT)/kernel
LOADER		= loader
HD_IMG		= boot.img
CARGO		= xargo
prefix		= arm-none-eabi-
CC 			= $(prefix)gcc
LD			= $(prefix)ld
FORMAT		= bare-app-$(ARCH)
LDFLAGS		= -ffreestanding -nostdlib -nostartfiles -O0

.PHONY: all clean iso cargo directories
TARGET = $(BUILD_ROOT)/$(LOADER)

SRC	= $(wildcard src/*.rs) $(wildcard $(KERNEL_ROOT)/*.rs)
OBJS	= target/$(TARGET_ARCH)/debug/librustberrypi.rlib
IPL		= $(BUILD_ROOT)/boot.o
all: directories $(TARGET)

directories: $(BUILD_ROOT)

$(BUILD_ROOT):
	test ! -d $(BUILD_ROOT) && mkdir $(BUILD_ROOT)

$(OBJS): $(SRC)
	$(CARGO) build --target $(TARGET_ARCH)

$(IPL) : $(KERNEL_ROOT)/boot.S
	$(CC) $(ASM_FLAGS) -c $< -o $@

$(TARGET): $(OBJS) $(IPL)
	$(CC) $(LDFLAGS) -T linker.ld -o $@ $(IPL) $(OBJS)

run: all
	qemu-system-arm -M raspi2 -kernel $(TARGET) -serial stdio

clean:
	@$(CARGO) clean
	@rm -rf build
