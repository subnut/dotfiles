#!/bin/sh
cd "$(dirname "$0")"
echo

echo '==== Common files ===='
./common/copy.sh
echo

if [ $(uname) = Linux ]
then
echo '==== Linux files ===='
./linux/copy.sh
echo
fi

if [ $(uname) = OpenBSD ]
then
echo '==== OpenBSD files ===='
./openbsd/copy.sh
echo
fi

echo '==== Deleting files ===='
cat .gitignore | while read FILE
do rm -rvf "$FILE"
done
echo

# vim: et ts=2 sts=0 sw=0:
