#!/bin/sh
cd "$(dirname "$0")"

test -d home/subnut             || mkdir -p home/subnut
test -d home/subnut/.zsh        || mkdir -p home/subnut/.zsh
test -d home/subnut/.config     || mkdir -p home/subnut/.config
test -d home/subnut/.local/bin  || mkdir -p home/subnut/.local/bin


cp -v ~/.Xdefaults          home/subnut
cp -v ~/.xinitrc            home/subnut
cp -v ~/.gitconfig          home/subnut
cp -v ~/.pythonrc           home/subnut
cp -v ~/.vimrc              home/subnut

cp -v ~/.fzf.zsh            home/subnut
cp -v ~/.zlogout            home/subnut
cp -v ~/.zshenv             home/subnut
cp -v ~/.zshrc              home/subnut

cp -rv ~/.zsh               home/subnut
cp -rv ~/.vim               home/subnut
cp -rv ~/.config/bspwm      home/subnut/.config
cp -rv ~/.config/sxhkd      home/subnut/.config
cp -rv ~/.config/qt5ct      home/subnut/.config
cp -rv ~/.config/fontconfig home/subnut/.config
cp -rv ~/.config/xsettingsd home/subnut/.config
cp -rv ~/.config/zathura    home/subnut/.config
cp -rv ~/.config/picom      home/subnut/.config

cp -v  ~/.gtkrc-2.0         home/subnut
cp -rv ~/.config/gtk-3.0    home/subnut/.config

cp -rv ~/.local/bin/bar     home/subnut/.local/bin
cp -rv ~/.local/bin/music   home/subnut/.local/bin
cp -rv ~/.local/bin/nothing home/subnut/.local/bin


# Sed is amazing!
sed -i '/^\[SettingsWindow\|^geometry=@ByteArray/d' \
  home/subnut/.config/qt5ct/qt5ct.conf


# vim: et ts=2 sts=2 sw=0:
