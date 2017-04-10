manifest = python3.5.manifest

exec_target = $(manifest)

clean-extra = clean-build

#extra_rules = \
	-e 's:\$$(PAL):../pal_loader:g' \

level = ../../
include ../../Makefile

clean-build:
	rm -rf *.manifest.sgx *.sig *.token
