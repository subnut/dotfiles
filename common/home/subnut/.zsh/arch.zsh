# yays () { yay -S $(yay -Ss $* | cut -d ' ' -f 1 | grep .  | fzf --multi) --needed }
# yayss () { yay -Ss $* }
# pacs () { doas pacman -S $(pacman -Ss $* | cut -d ' ' -f 1 | grep . | cut -f 2 -d '/' | fzf --multi --preview-window 'right:50%:hidden:wrap' --preview 'pacman -Si {}') --needed }
# alias pacsss="pacman -Ss"
# pacss() { pacman -Ss $* | cut -f 2 -d'/' | cut -f 1 -d' '| grep . | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Si {}' }
pacr () { doas pacman -Rns $(pacman -Qeq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat') }
# pacrr () { doas pacman -R $(pacman -Qq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat') }

# vim: set nowrap:
