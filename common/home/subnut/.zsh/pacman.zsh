pacs () { doas pacman -S --needed $(pacman -Ssq $* | fzf --multi --preview-window 'right:50%:hidden:wrap' --preview 'pacman -Si {}') }
pacr () { doas pacman -Rns $(pacman -Qeq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat') }
# yays () { yay -S $(yay -Ssq $*) --needed }
# yayss () { yay -Ss $* }
# alias pacsss="pacman -Ss"
# pacss() { pacman -Ssq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Si {}' }
# pacrr () { doas pacman -R $(pacman -Qq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat') }

# vim: set nowrap:
