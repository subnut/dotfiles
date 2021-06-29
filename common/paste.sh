#!/bin/sh
cd "$(dirname "$0")"

test -d /home/subnut/.zsh        || mkdir -p /home/subnut/.zsh
test -d /home/subnut/.config     || mkdir -p /home/subnut/.config
test -d /home/subnut/.local/bin  || mkdir -p /home/subnut/.local/bin

cp -rv home/subnut /home

# vim: et ts=2 sts=0 sw=0:
