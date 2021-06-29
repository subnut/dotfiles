#!/bin/sh
cd "$(dirname "$0")"

test -d home/subnut             || mkdir -p home/subnut
test -d home/subnut/.zsh        || mkdir -p home/subnut/.zsh
test -d home/subnut/.config     || mkdir -p home/subnut/.config
test -d home/subnut/.local/bin  || mkdir -p home/subnut/.local/bin

cp -v  ~/.zprofile          home/subnut
cp -rv ~/.local/bin/light   home/subnut/.local/bin

# vim: et ts=2 sts=0 sw=0:
