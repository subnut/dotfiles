pacs   () { pacman -Ssq $*  | fzf --multi --preview 'pacman -Si {}'| doas pacman -S --needed - }
pacr   () { pacman -Qeqt $* | fzf --multi --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups"' | doas pacman -Rns - }
pacrr  () { pacman -Qeq $*  | fzf --multi --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups"' | doas pacman -Rns - }
pacrrr () { pacman -Qq $*   | fzf --multi --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups"' | doas pacman -Rns - }
# yays () { yay -Ssq $* | yay -S --needed - }
# yayss () { yay -Ss $* }
# alias pacsss="pacman -Ss"
# pacss() { pacman -Ssq $* | fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Si {}' }

# vim: set nowrap:
