#!/bin/bash

CODESIGN_IDENTITY='84F6733015E5B993E983C1919E50244AE945CC34'

# ------------------------------------------------------------
PATH=/bin:/sbin:/usr/bin:/usr/sbin; export PATH

if [ ! -e "$1" ]; then
    echo "[ERROR] Invalid argument: '$1'"
    exit 1
fi

# ------------------------------------------------------------
# sign
cd "$1"
find * -name '*.app' -or -path '*/bin/*' | sort -r | while read f; do
    echo -ne '\033[33;40m'
    echo "code sign $f"
    echo -ne '\033[0m'

    echo -ne '\033[31;40m'
    codesign \
        --force \
        --deep \
        --sign "$CODESIGN_IDENTITY" \
        "$f"
    echo -ne '\033[0m'
done

# verify
find * -name '*.app' -or -path '*/bin/*' | sort -r | while read f; do
    echo -ne '\033[31;40m'
    codesign --verify --deep "$f"
    echo -ne '\033[0m'
done
