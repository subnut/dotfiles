# yays () { yay -S $(yay -Ssq $*) --needed }
# yayss () { yay -Ss $* }
# pacs () { doas pacman -S $(pacman -Ssq $* | fzf --multi --preview-window 'right:50%:hidden:wrap' --preview 'pacman -Si {}') --needed }
# alias pacsss="pacman -Ss"
# pacss() { pacman -Ssq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Si {}' }
pacr () { doas pacman -Rns $(pacman -Qeq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat') }
# pacrr () { doas pacman -R $(pacman -Qq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat') }

# vim: set nowrap:
