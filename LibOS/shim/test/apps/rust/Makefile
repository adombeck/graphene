manifest = hello.manifest

target = target/debug/hello
exec_target = $(manifest)

clean-extra = clean-build

level = ../../
include ../../Makefile

target/debug/hello:
	cargo rustc -- -C relocation-model=static

clean-build:
	cargo clean
	rm -rf *.manifest.sgx *.sig *.token
