# vim: fdm=marker nowrap sw=0 ts=4 sts=4 et
# NOTE: for any kind of unknown term, see `man 1 zshall`
if which stty > /dev/null; then
    stty -echo
fi
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _approximate _ignored
zstyle ':completion:*' matcher-list '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


## Config
setopt AUTOPUSHD
setopt CORRECT                  # [nyae]? (Also see $SPROMPT)
setopt EXTENDED_HISTORY         # add timestamp to .zsh_history
setopt HIST_IGNORE_DUPS         # ignore duplicate
setopt HIST_IGNORE_SPACE        # command prefixed by space are incognito
setopt HIST_REDUCE_BLANKS       # RemoveTrailingWhiteSpace
setopt HIST_VERIFY              # VERY IMPORTANT. `sudo !!` <enter> doesn't execute directly. instead, it just expands.
setopt INC_APPEND_HISTORY       # immediately _append_ to HISTFILE instead of _replacing_ it _after_ the shell exits
setopt INTERACTIVE_COMMENTS     # Allow comments using '#' in interactive mode
bindkey "^[" vi-cmd-mode        # vi-mode
typeset -ga pre{cmd,exec}_functions

## PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=./:$PATH
typeset -U PATH path    # remove duplicates


source ~/.zsh/git.zsh
source ~/.zsh/misc.zsh
source ~/.zsh/key_mappings.zsh
source ~/.zsh/prompt.zsh
source ~/.fzf.zsh


[ "$TERM" = "xterm-kitty" ]        && source ~/.zsh/kitty.zsh
[ ${#commands[(Ie)pacman]} -eq 1 ] && source ~/.zsh/pacman.zsh


test ! -d ~/.zsh/OMZ_snippets && \
    mkdir -p ~/.zsh/OMZ_snippets
source ~/.zsh/OMZ_snippets/key-bindings.zsh || \
    curl -L http://github.com/ohmyzsh/ohmyzsh/raw/master/lib/key-bindings.zsh \
    -o  ~/.zsh/OMZ_snippets/key-bindings.zsh
source ~/.zsh/OMZ_snippets/clipboard.zsh || \
    curl -L http://github.com/ohmyzsh/ohmyzsh/raw/master/lib/clipboard.zsh \
    -o  ~/.zsh/OMZ_snippets/clipboard.zsh


### ohmyzsh plugins
#   OMZ::lib/termsupport.zsh \
#   OMZ::plugins/sudo/sudo.plugin.zsh

##### End of plugins ##########################



# Set terminal title
function title_precmd   { print -Pn "\e]0;%n@%m: %~\a"; }       # user@host: ~/cur/dir
function title_preexec  { printf "\e]0;%s\a" "${2//    / }"; }  # name of running command
precmd_functions+=title_precmd
preexec_functions+=title_preexec

# Show execution time
zmodload zsh/datetime
typeset -ga epochtime_preexec
function _exectime_precmd {
    # Define this function AFTER the very first prompt has been shown
    # Otherwise, it shows a bogus value in the RPROMPT, since
    # epochtime_preexec is not defined yet
    function _exectime_precmd {
        RPROMPT="%f"
        if [[ ${epochtime_preexec[1]} -eq ${epochtime[1]} ]]; then
            local nanosec=$(( epochtime[2] - epochtime_preexec[2] ))
            local sec="$(( nanosec / 1000000000.0 ))"
            RPROMPT="${sec:0:5}s$RPROMPT"   # 0.xxx -- 5 chars
        else
            local sec
            sec=$(( epochtime[1] - epochtime_preexec[1] ))
            RPROMPT="$(( sec % 60 ))s$RPROMPT"
            [[ $(( sec /= 60 )) -gt 0 ]] &&
                RPROMPT="$(( sec % 60 ))m $RPROMPT"     # mins
            [[ $(( sec /= 60 )) -gt 0 ]] &&
                RPROMPT="$(( sec % 24 ))h $RPROMPT"     # hours
            [[ $(( sec /= 60 )) -gt 0 ]] &&
                RPROMPT="$(( sec % 24 ))d $RPROMPT"     # days
        fi
        RPROMPT="%F{7}$RPROMPT"
    }
}
function _exectime_preexec {
    epochtime_preexec=($epochtime)
}
preexec_functions+=_exectime_preexec
precmd_functions+=_exectime_precmd

