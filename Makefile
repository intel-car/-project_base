TARGET = pchroot
WRAPPER = launch.sh
SCRIPTS := \
	$(wildcard launch.sh) \
	$(wildcard dev/.file) \
	$(wildcard sys/.file) \
	$(wildcard proc/.file) \
	$(wildcard root/*) \
	$(wildcard root/*/*) \
	$(wildcard root/*/*/*) \
	$(wildcard root/*/*/*/*)

TARPARAMS ?= -j

$(TARGET): $(WRAPPER) $(SCRIPTS) Makefile
	{ \
		sed -e "s/\$$TARPARAMS/$(TARPARAMS)/" \
			-e "s/VERSION=.*/VERSION='$(shell)'/" \
			$(WRAPPER) \
		&& tar --owner=root --group=root -c $(TARPARAMS) $(SCRIPTS) \
		&& chmod +x /dev/stdout \
	;} > $(TARGET) || ! rm -f $(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: clean
