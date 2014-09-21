TARGET = pchroot
WRAPPER = launch.sh
SCRIPTS := \
	$(wildcard lib/*) \
	$(wildcard lib/*/*) \
	$(wildcard lib/*/*/*) \
	$(wildcard lib/*/*/*/*) \
        $(wildcard bin/*) \
	$(wildcard menu.sh) \
	$(wildcard launch.sh) \
	$(wildcard bin/*) \
	$(wildcard apps/*)

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
