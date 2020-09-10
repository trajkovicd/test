#!/bin/sh

set -e
set -u

# Populate /opt/ssstm directory
function populate() {
    WORKD=${1:-/opt/ssstm}
    DIST="/dist"

    rm -rf $WORKD/*
    mkdir -p $WORKD

    # populate rhat lib structure
    mkdir -p $WORKD/lib $WORKD/lib64

    install -o root -g root -m 0555 $DIST/lib32/shared.so $WORKD/lib
    install -o root -g root -m 0555 $DIST/lib64/shared.so $WORKD/lib64

    # populate debian lib structure
    mkdir -p $WORKD/lib32 $WORKD/lib/x86_64-linux-gnu

    install -o root -g root -m 0555 $DIST/lib32/shared.so $WORKD/lib32
    install -o root -g root -m 0555 $DIST/lib64/shared.so $WORKD/lib/x86_64-linux-gnu

    # setup environment
    mkdir -p $WORKD/etc
    echo '/opt/ssstm/$LIB/shared.so' > $WORKD/etc/ld.so.preload
}

populate "/opt/ssstm"

# If we have an interactive container
if [ "$#" -gt 0 ]; then
    eval "exec $@"
else 
    exec sleep infinity
fi

# Will not reach here 
exit 0
