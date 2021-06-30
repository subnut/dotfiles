#!/bin/sh
cd "$(dirname "$0")"

cp -rv home/subnut /home


run() { echo "> $*"; sh -c "$*"; }

if test -x /usr/bin/pacman
then
  PACFLAGS='--needed --noconfirm'
  run sudo pacman -Syu $PACFLAGS '$(cat pacman_installed_packages)'
  run git clone https://aur.archlinux.org/yay-bin.git --depth 1
  run cd yay-bin '&&' makepkg -si $PACFLAGS
  run rm -rf yay-bin
  run yay -S $PACFLAGS '$(cat AUR_installed_packages)'
fi

# vim: et ts=2 sts=0 sw=0:
