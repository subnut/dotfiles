(( ${+commands[stty]} )) && {
    stty -echo          # Don't echo keypresses while zsh is starting
    stty stop undef     # unbind ctrl-s from stty stop to allow fwd-i-search
}


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
source ~/.zsh/keybindings.zsh
source ~/.zsh/prompt.zsh
source ~/.zsh/misc.zsh


## Config files corresponding to the commands ...
() {
    local command; for command in "$@"; do
        (( ${+commands[$command]} )) && [[ -f ~/.zsh/${command}.zsh ]] &&
        source ~/.zsh/${command}.zsh
    done
} git fzf pacman
# ... mentioned in the previous line


## oh-my-zsh scripts
test ! -d ~/.zsh/OMZ_snippets && \
    mkdir -p ~/.zsh/OMZ_snippets
source ~/.zsh/OMZ_snippets/clipboard.zsh || \
    curl -L http://github.com/ohmyzsh/ohmyzsh/raw/master/lib/clipboard.zsh \
    -o  ~/.zsh/OMZ_snippets/clipboard.zsh


# vim: fdm=marker nowrap sw=0 ts=4 sts=4 et
