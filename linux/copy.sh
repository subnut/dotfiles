#!/bin/sh
cd "$(dirname "$0")"

rm -rf home
rm -rf root


test -d home/subnut             || mkdir -p home/subnut
test -d home/subnut/.config     || mkdir -p home/subnut/.config
test -d home/subnut/.local/bin  || mkdir -p home/subnut/.local/bin
test -d root/usr/local/bin      || mkdir -p root/usr/local/bin
test -d root/etc                || mkdir -p root/etc

cp -v  ~/.zprofile                home/subnut
cp -rv ~/.local/bin/mpv           home/subnut/.local/bin
cp -rv ~/.local/bin/battery       home/subnut/.local/bin
cp -rv ~/.local/bin/volume_bar    home/subnut/.local/bin
cp -rv ~/.local/bin/get_volume.c  home/subnut/.local/bin

cp -rv ~/.config/pacman           home/subnut/.config/pacman

cp -rv /usr/local/bin/light       root/usr/local/bin
cp -rv /etc/zzz.d                 root/etc

cp -v  /etc/acpi/handler.sh       root/etc/acpi
cp -v  /etc/rc.local              root/etc
cp -v  /etc/asound.conf           root/etc
cp -v  /etc/doas.conf             root/etc
cp -v  /etc/sysctl.conf           root/etc

run() { echo "$*"; sh -c "$*"; }

if test -x /usr/bin/pacman
then
  cd Artix
  run 'pacman -Qenq > pacman_installed_packages'
  echo 'Saving AUR_installed_packages'
  bash <<EOF
pacman -Qemq |
grep -v "\$(
       (
         cd PKGBUILDs
         for PKGBUILD in */PKGBUILD
         do ( source \$PKGBUILD; echo \${pkgname[@]}; )
         done
       ) | tr '\\n' ' ' | sed -e 's/ +/ /g' | sed 's/^ *\| *$//g' | sed 's/ /\\\\|/g'
)" > AUR_installed_packages
EOF
fi

# vim: et ts=2 sts=0 sw=0 nowrap:
