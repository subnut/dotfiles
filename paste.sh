#!/bin/sh
cd "$(dirname "$0")"
echo

if ! test $(whoami) = subnut
then
	echo "$(whoami) is a traitor. Shoo!" >&2
	echo "HINT: username must be subnut" >&2
	exit 2
fi

echo '==== Common files ===='
./common/paste.sh
echo

if [ $(uname) = Linux ]
then
echo '==== Linux files ===='
./linux/paste.sh
echo
echo '###### ALSA note ######'
echo 'If alsa shows error "unable to open slave", then'
echo "	cp $(pwd)/etc_modprobe.d_alsa.conf /etc/modprobe.d/alsa.conf"
echo
fi

if [ $(uname) = OpenBSD ]
then
echo '==== Linux files ===='
./openbsd/paste.sh
echo
fi
