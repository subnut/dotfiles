#!/bin/sh
cd "$(dirname "$0")"

if ! test "$(sudo whoami)" = root
then
  echo "ERROR: This script needs sudo access to work" >&2
  echo "Run visudo and configure sudo correctly" >&2
  echo "HINT: Is subnut added to :wheel ?" >&2
  echo "      usermod -a -G wheel subnut" >&2
  exit 1
fi

cp -rv home/subnut /home
find root -type f | while read FILE
do
  sudo cp -v "$FILE"   "/${FILE#root}"
  sudo chown root:root "/${FILE#root}"
done


run() { echo "> $*"; sh -c "$*"; }

if test -x /usr/bin/pacman
then
  PACFLAGS='--needed --noconfirm'
  run sudo pacman -Syu $PACFLAGS '$(cat pacman_installed_packages)'
  run sudo sed -i '/#Color/s/^#//' /etc/pacman.conf  # Enable color in pacman
  run git clone https://aur.archlinux.org/yay-bin.git --depth 1
  run cd yay-bin '&&' makepkg -si $PACFLAGS
  run rm -rf yay-bin
  run yay --removemake --save
  run yay -S $PACFLAGS '$(cat AUR_installed_packages)'
  echo
  echo "###### XORG note ######"
  echo "You don't need dbus or elogind. Remove them from Startup Services NOW!"
  echo "Xorg can run perfectly fine without elogind. Use Xorg.wrap"
  echo
  echo "First, ensure that /usr/lib/Xorg.wrap is owned by root"
  echo "Then, run the following command AS ROOT to make it setuid-root -"
  echo "    chmod u+s /usr/lib/Xorg.wrap"
  echo
  echo "By default /usr/bin/Xorg should be a shell script that simply executes"
  echo "/usr/lib/Xorg.wrap if available, else /usr/lib/Xorg (the actual Xserver)"
  echo "Do not forget to check Xorg.wrap(1) manpage"
  echo
fi

# vim: et ts=2 sts=0 sw=0:
