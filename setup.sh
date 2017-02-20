#!/bin/bash

set -e

echo "Checking if running in correct OS..."
([[ `lsb_release -a 2> /dev/null` == *"14.04"* ]] || [[ `lsb_release -a 2> /dev/null` == *"16.04"* ]]) || (echo "Wrong OS. Run on Ubuntu 14.04 or Ubuntu 16.04."; exit 1)

DIR=$PWD

# Get sudo password in the beginning
sudo true

# Install required packages
PACKAGES_TO_INSTALL=""
for PACKAGE in build-essential autoconf gawk python-protobuf python-crypto
do
  dpkg -s $PACKAGE > /dev/null || PACKAGES_TO_INSTALL="$PACKAGES_TO_INSTALL $PACKAGE"
done
[[ -z $PACKAGES_TO_INSTALL ]] || sudo apt install $PACKAGES_TO_INSTALL

# Generate signing key
[[ -f $DIR/Pal/src/host/Linux-SGX/signer/enclave-key.pem ]] || (cd $DIR/Pal/src/host/Linux-SGX/signer && openssl genrsa -3 -out enclave-key.pem 3072)

# Make clean
make clean

# Make with debug symbols and SGX support
make SGX=1 DEBUG=1

cd $DIR/Pal/src/host/Linux-SGX/sgx-driver
make
sudo ./load.sh

sudo sysctl vm.mmap_min_addr=0

cd $DIR/LibOS/shim/test/native
make SGX=1 && make SGX_RUN=1
( [[ -f ./pal_loader ]] && ./pal_loader SGX helloworld ) || true
( [[ -f ./pal ]] && ./pal helloworld ) || true

cd $DIR/LibOS/shim/test/apps/python
sed -i "s/^target =/#target =/g" Makefile
make SGX=1 && make SGX_RUN=1
./python.manifest.sgx scripts/helloworld.py  
