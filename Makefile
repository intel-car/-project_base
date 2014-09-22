TARGET = pchroot
SRC_BINARIES = busybox
TARPARAMS ?= -j
WRAPPER = launch.sh
SCRIPTS := \
	$(wildcard launch.sh) \
	$(wildcard root/*) \
	$(wildcard root/*/*) \
	$(wildcard root/*/*/*) \
	$(wildcard root/*/*/*/*) \
	$(wildcard root/*/*/*/*/*)


$(TARGET): $(WRAPPER) $(SCRIPTS) $(SRC_BINARIES) Makefile
	{ \
		sed -e "s/\$$TARPARAMS/$(TARPARAMS)/" \
			-e "s/VERSION=.*/VERSION='$(shell)'/" \
			$(WRAPPER) \
		&& tar --owner=root --group=root -c $(TARPARAMS) $(SCRIPTS) \
		&& chmod +x /dev/stdout \
	;} > $(TARGET) || ! rm -f $(TARGET)

$(SRC_BINARIES): 
	sh scripts/busybox

clean:
	rm -f $(TARGET)
	sh scripts/clean

.PHONY: clean
