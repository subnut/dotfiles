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


alias vimtemp="vim +'set buftype=nowrite'"
alias vimrc="vim ~/.vimrc"
alias init.vim="nvim ~/.config/nvim/init.vim"
alias bspwmrc='$EDITOR ~/.config/bspwm/bspwmrc'
alias sxhkdrc='$EDITOR ~/.config/sxhkd/sxhkdrc'
alias zshrc='$EDITOR ~/.zshrc'

alias ra=ranger
alias shrug="echo -n '¯\_(ツ)_/¯' | clipcopy"
# alias copy=clipcopy

(( ${+commands[abduco]} )) && {
	function abduco_ {
		[ $(ps p $(ps p $$ o ppid h) o comm h) = abduco ] && {
			printf "%s '%s'\n" 'WARNING!!! This shell is already running under abduco session' \
			$(ps p $(ps p $$ o ppid h) o command h | tr ' ' '\n' | sed -n '/^-c$/,/zsh/{n
p
}')
			echo 'If you somehow accidentally end up attaching to a session from inside that'
			echo 'session, you will create an infinte loop, inflicting stress on your machine'
			printf %s 'Are you sure you want to continue? [Y/n] '
			local ANSWER
			read ANSWER
			if [ -z "$ANSWER" ] || echo $ANSWER | grep -q '^[Yy]'; then :;
			else echo Aborted; return 1;
			fi
		}
		abduco "$@"
	}
alias abduco=abduco_
}


my_ssh ()
{
  (
    unset  DISPLAY   # make gpg-agent use pinentry-curses instead of pinentry-gtk-2
    export SSH_AUTH_SOCK="$_SSH_AUTH_SOCK"
    export SSH_AGENT_PID="$_SSH_AGENT_PID"
    unset _SSH_AUTH_SOCK
    unset _SSH_AGENT_PID
    ssh "$@"      # <- this line is the reason of the NOTE regarding the `alias ssh`
  )
}
alias ssh=my_ssh  # NOTE: this alias MUST come after the my_ssh function definition
compdef my_ssh=ssh # Use the completion of ssh for my_ssh
my_rsync ()
{
  (
    unset  DISPLAY   # make gpg-agent use pinentry-curses instead of pinentry-gtk-2
    export SSH_AUTH_SOCK="$_SSH_AUTH_SOCK"
    export SSH_AGENT_PID="$_SSH_AGENT_PID"
    unset _SSH_AUTH_SOCK
    unset _SSH_AGENT_PID
    rsync "$@"      # <- this line is the reason of the NOTE regarding the `alias rsync`
  )
}
alias rsync=my_rsync  # NOTE: this alias MUST come after the my_rsync function definition
compdef my_rsync=rsync # Use the completion of rsync for my_rsync
my_scp ()
{
  (
    unset  DISPLAY   # make gpg-agent use pinentry-curses instead of pinentry-gtk-2
    export SSH_AUTH_SOCK="$_SSH_AUTH_SOCK"
    export SSH_AGENT_PID="$_SSH_AGENT_PID"
    unset _SSH_AUTH_SOCK
    unset _SSH_AGENT_PID
    scp "$@"      # <- this line is the reason of the NOTE regarding the `alias scp`
  )
}
alias scp=my_scp  # NOTE: this alias MUST come after the my_scp function definition
compdef my_scp=scp # Use the completion of scp for my_scp

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


