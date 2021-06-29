#!/bin/sh
cd "$(dirname "$0")"

pkg_add -l openbsd_pkg_list || exit $?
cp -rv root/etc /

X=home/subnut/.local/bin
su subnut -c "mkdir -p $X"
X=$X/mpv
su subnut -c "cp $X /$X"

# vim: et ts=2 sts=0 sw=0:
