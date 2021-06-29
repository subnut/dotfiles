#!/bin/sh
cd "$(dirname "$0")"

errexit()
{
  EXITCODE=$1
  shift
  echo
  echo "$*" >&2
  exit $EXITCODE
}

pkg_add -l openbsd_pkg_list || errexit $? Run "\"$0\"" as root
cp -rv root/etc /

X=home/subnut/.local/bin
su subnut -c "mkdir -p $X"
X=$X/mpv
su subnut -c "cp $X /$X"

# vim: et ts=2 sts=0 sw=0:
