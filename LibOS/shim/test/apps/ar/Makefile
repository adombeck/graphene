manifests = ar.manifest

exec_target = $(manifests)

clean-extra += clean-tmp

level = ../../
include ../../Makefile

clean-tmp:
	rm -f ar.manifest.sgx ar.sig ar.token
