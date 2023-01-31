include common.mk

all:
	$(MAKE) -C v1
	$(MAKE) -C v2

clean:
	rm -f $(CLEAN_LIST)
	$(MAKE) -C v1 clean
	$(MAKE) -C v2 clean

check: all
	@echo "The two mod files should be different, as they have different interfaces:"
	@echo -n "    ==> "
	-@diff v1/libmod.mod v2/libmod.mod || true
	@echo "The two .so files should be identical if the ABI is stable"
	@echo -n "    ==> "
	@diff v1/libfoo.so v2/libfoo.so -s