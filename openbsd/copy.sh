#!/bin/sh
cd "$(dirname "$0")"

rm -rf home
rm -rf root


test -d root/etc                || mkdir -p root/etc
test -d home/subnut/.local/bin  || mkdir -p home/subnut/.local/bin


cp -v  /etc/rc.conf.local   root/etc
cp -v  /etc/wsconsctl.conf  root/etc
cp -v  /etc/sysctl.conf     root/etc
cp -v  /etc/doas.conf       root/etc
cp -rv ~/.local/bin/mpv     home/subnut/.local/bin

pkg_info -mz > openbsd_pkg_list

# vim: et ts=2 sts=0 sw=0:
