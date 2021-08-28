## `zsh-newuser-install`
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000


## `compinstall`
zstyle ':completion:*' completer _complete _approximate _ignored
zstyle ':completion:*' matcher-list '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit


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
zmodload zsh/terminfo
typeset -ga pre{cmd,exec}_functions


## PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=./:$PATH
typeset -U PATH path    # remove duplicates


## Set terminal title
function title_precmd   { print -Pn "\e]0;%n@%m: %~\a"; }       # user@host: ~/cur/dir
function title_preexec  { printf "\e]0;%s\a" "${2//    / }"; }  # name of running command
precmd_functions+=title_precmd
preexec_functions+=title_preexec


## Other config files
export ZDOTDIR=${ZDOTDIR-$HOME}
source $ZDOTDIR/.zsh/misc.zsh
source $ZDOTDIR/.zsh/prompt.zsh
source $ZDOTDIR/.zsh/keybindings.zsh


## Config files corresponding to the commands ...
() {
    local command; for command in "$@"; do
        (( ${+commands[$command]} )) && [[ -f $ZDOTDIR/.zsh/${command}.zsh ]] &&
        source $ZDOTDIR/.zsh/${command}.zsh
    done
} git fzf pacman
# ... mentioned in the previous line


## oh-my-zsh scripts
[[ -d $ZDOTDIR/.zsh/OMZ_snippets ]] || mkdir -p $ZDOTDIR/.zsh/OMZ_snippets
[[ -f $ZDOTDIR/.zsh/OMZ_snippets/clipboard.zsh ]] || \
    curl -L http://github.com/ohmyzsh/ohmyzsh/raw/master/lib/clipboard.zsh \
    -o $ZDOTDIR/.zsh/OMZ_snippets/clipboard.zsh
source $ZDOTDIR/.zsh/OMZ_snippets/clipboard.zsh


## Terminal compatibility/tweaks
(( ${+commands[stty]} )) && {
    <>$TTY stty -echo                   # Don't echo keypresses while zsh is starting
    <>$TTY stty stop undef              # unbind ctrl-s from stty stop to allow fwd-i-search
    <>$TTY stty erase ${terminfo[kbs]}  # vim :term has ^H in $terminfo[kbs] but sets ^? in stty erase
}


# vim: fdm=marker nowrap sw=0 ts=4 sts=4 et
