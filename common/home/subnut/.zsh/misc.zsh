alias ":q"=exit

alias py=python3
export PYTHONSTARTUP=~/.pythonrc

alias l='ls -lA'
alias la='ls -la'

#alias cal3="cal -3"
#alias qr="qrencode -t UTF8"

export EDITOR=vim
export DIFFPROG=vimdiff
alias n=vim
# if [[ $TERM =~ 'st-256color' ]]; then
# 	export EDITOR=nvim
# 	export DIFFPROG="nvim -d"
# 	alias n=nvim
# fi
alias nvimvenv="source ~/.config/nvim/venv/bin/activate"
alias nvimdiff="nvim -d"
alias nlsp="nvim --cmd 'let g:enable_lsp = 1'"


alias vimrc="vim ~/.vimrc"
alias init.vim="nvim ~/.config/nvim/init.vim"
alias bspwmrc='$EDITOR ~/.config/bspwm/bspwmrc'
alias sxhkdrc='$EDITOR ~/.config/sxhkd/sxhkdrc'
alias zshrc='$EDITOR ~/.zshrc'

alias ra=ranger
alias shrug="echo -n '¯\_(ツ)_/¯' | clipcopy"
# alias copy=clipcopy

bspwm_delete_monitor() { #{{{
	local monitor
	local desktop
	for monitor in "$@"
	do
		for desktop in $(bspc query -D -m "$monitor")
		do
			bspc desktop "$desktop".occupied --to-monitor focused
		done
		bspc monitor "$monitor" --remove
	done
}
_bspwm_delete_monitor() { compadd $(bspc query -M -m .!focused --names) }
compdef _bspwm_delete_monitor bspwm_delete_monitor #}}}


# media_control() { # {{{
# 	local input
# 	while true
# 	do
# 		clear
# 		echo $input
# 		printf "> "
# 		read -k 1 input
# 		case "$input" in
# 			(q) clear; return;;
# 			(p|\ ) playerctl -a play-pause;;
# 			(P) playerctl previous ;;
# 			(n) playerctl next;;
# 			(s) playerctl stop;;
# 			(0) playerctl position 0;;
# 			(,) playerctl position 5-;;
# 			(\.) playerctl position 5+;;
# 			(+|=) amixer set Master 5%+ &>/dev/null;;
# 			(-) amixer set Master 5%- &>/dev/null;;
# 			esac
# 		done
# } # }}}


