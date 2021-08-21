# vim: fdm=marker nowrap sw=0 ts=4 sts=4 et
# NOTE: for any kind of unknown term, see `man 1 zshall`


## Don't echo keypresses while zsh is starting
if which stty 1,2>/dev/null; then
    stty -echo
fi


## `zsh-newuser-install`
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000
bindkey -e


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
bindkey "^[" vi-cmd-mode        # vi-mode
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


## Prompt
source ~/.zsh/prompt.zsh
source ~/.zsh/transient_prompt.zsh


## Others
source ~/.zsh/misc.zsh
source ~/.zsh/keybindings.zsh


## Source the .zsh files corresponding to the commands ...
() {
    local command; for command in "$@"; do
        (( ${#commands[(Ie)$command]} )) && [[ -f ~/.zsh/${command}.zsh ]] &&
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


## Dont use kitty
## It uses its OWN fork or glfw! If that isn't bloat, I don't know what is.
[ "$TERM" = "xterm-kitty" ] && {
#    alias icat='kitty +kitten icat'
#    alias ranger="ranger --cmd 'set preview_images_method kitty'"
    print -P '%B%U%F{1}kitty uses its own fork of glfw%f%u%b\n'
}
