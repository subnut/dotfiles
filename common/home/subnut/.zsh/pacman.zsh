pacs () { pacman -Ssq $* | fzf --multi --preview-window 'right:50%:hidden:wrap' --preview 'pacman -Si {}' | doas pacman -S --needed - }
pacr () { pacman -Qeqt $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat' | doas pacman -Rns - }
pacrr () { pacman -Qeq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat' | doas pacman -Rns - }
# yays () { yay -Ssq $* | yay -S --needed - }
# yayss () { yay -Ss $* }
# alias pacsss="pacman -Ss"
# pacss() { pacman -Ssq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Si {}' }
# pacrrr () { pacman -Qq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat' | doas pacman -Rns - }

# vim: set nowrap:
