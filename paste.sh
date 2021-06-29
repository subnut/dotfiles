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
echo 'If alsa shows error "unable to open slave", then'
echo '	cp etc_modprobe.d_alsa.conf /etc/modprobe.d/alsa.conf'
echo
fi

if [ $(uname) = OpenBSD ]
then
echo '==== Linux files ===='
./openbsd/paste.sh
echo
fi
