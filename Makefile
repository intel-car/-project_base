TARGET = pchroot
SRC_BINARIES = \
	 checks \
	 $(TARGET) \
	 busybox \
	 glibc

TARPARAMS ?= -j
WRAPPER = launch.sh
SCRIPTS := \
	$(wildcard launch.sh) \
	$(wildcard root/*) \
	$(wildcard root/*/*) \
	$(wildcard root/*/*/*) \
	$(wildcard root/*/*/*/*) \
	$(wildcard root/*/*/*/*/*)

all:
	@make $(SRC_BINARIES)

$(TARGET): $(WRAPPER) $(SCRIPTS) $(SRC_BINARIES) Makefile
	{ \
		sed -e "s/\$$TARPARAMS/$(TARPARAMS)/" \
			-e "s/VERSION=.*/VERSION='$(shell)'/" \
			$(WRAPPER) \
		&& tar --owner=root --group=root -c $(TARPARAMS) $(SCRIPTS) \
		&& chmod +x /dev/stdout \
	;} > $(TARGET) || ! rm -f $(TARGET)

busybox:
	@make checks
	make -C src/busybox pchroot_defconfig
	make -C src/busybox
	make -C src/busybox install
glibc:
	@make checks
	@sh scripts/glibc-2.20

checks:
	@sh scripts/checks

clean:
	@rm -f $(TARGET)
	@make -C src/busybox clean
	@make -C src/glibc-2.20/build clean
	@rm -rf root

mrproper:
	@rm -f $(TARGET)
	@rm -rf src
	@rm -rf root

.PHONY: clean
