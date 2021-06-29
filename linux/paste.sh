#!/bin/sh
cd "$(dirname "$0")"

cp -rv home/subnut /home


run() { echo "$*"; sh -c "$*"; }

if test -x /usr/bin/pacman
then
  run 'sudo pacman -Syu --needed $(cat pacman_installed_packages)'
fi

# vim: et ts=2 sts=0 sw=0:
