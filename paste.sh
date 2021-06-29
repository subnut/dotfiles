#!/bin/sh
cd "$(dirname "$0")"
./common/paste.sh

if [ $(uname) = Linux ]
then ./linux/paste.sh
fi

if [ $(uname) = OpenBSD ]
then ./openbsd/paste.sh
fi
