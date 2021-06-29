#!/bin/sh
cd "$(dirname "$0")"
echo

echo '==== Common files ===='
./common/paste.sh
echo

if [ $(uname) = Linux ]
then
echo '==== Linux files ===='
./linux/paste.sh
echo
fi

if [ $(uname) = OpenBSD ]
then
echo '==== Linux files ===='
./openbsd/paste.sh
echo
fi
