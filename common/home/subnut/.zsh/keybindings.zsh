## Fancy Ctrl-Z
fancy_ctrl_z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER=" fg"
    zle accept-line
  fi
}
zle -N fancy_ctrl_z
bindkey '^Z' fancy_ctrl_z


## Show completion dots
zle -A expand-or-complete _expand-or-complete
expand-or-complete_with_dots() {
  # print -Pn "%F{red}…%f"
  print -Pn "%F{1}...%f"
  zle _expand-or-complete
  zle reset-prompt
}
zle -N expand-or-complete expand-or-complete_with_dots
# bindkey '^I' expand_or_complete_with_dots


## Create a new keymap, and make it main
bindkey -N mymap
bindkey -A mymap main
bindkey -R "\x00"-"\xFF" self-insert


## Keybindings
zmodload zsh/terminfo
function bindkey {
  (( ${+terminfo[$1]} )) && builtin bindkey "${terminfo[$1]}" "$2"
}

# bindkey   kcuu1   up-line-or-history      # Up
# bindkey   kcud1   down-line-or-history    # Down
bindkey   kcuu1   up-line-or-search       # Up
bindkey   kcud1   down-line-or-search     # Down
bindkey   kcub1   backward-char           # Left
bindkey   kcuf1   forward-char            # Right
bindkey   kend    end-of-line             # End
bindkey   khome   beginning-of-line       # Home
bindkey   kdch1   delete-char             # Delete
bindkey   kbs     backward-delete-char    # Backspace
bindkey   kcbt    reverse-menu-complete   # Shift+Tab
bindkey   kclr    clear-screen

(( ${+functions[bindkey]} ))  &&
  unfunction bindkey


# bindkey '^A'
# bindkey '^B'
# bindkey '^C'
bindkey '^D'  vi-unindent
# bindkey '^E'
# bindkey '^F'
bindkey '^G'  send-break            # zsh default
bindkey '^H'  backward-delete-char  # BS  (Backspace)
bindkey '^I'  expand-or-complete    # HT  (Horizontal Tab)
bindkey '^J'  accept-line           # LF  (Line feed)
# bindkey '^K'
bindkey '^L'  clear-screen
bindkey '^M'  accept-line           # CR  (Carriage Return)
bindkey '^N'  down-line-or-search
bindkey '^O'  vi-open-line-below    # Madlad
bindkey '^P'  up-line-or-search
bindkey '^Q'  vi-quoted-insert
bindkey '^R'  history-incremental-search-backward   # zsh default
bindkey '^S'  history-incremental-search-forward    # zsh default
bindkey '^T'  vi-indent
bindkey '^U'  backward-kill-line
bindkey '^V'  vi-quoted-insert
bindkey '^W'  backward-kill-word
# bindkey '^X'
bindkey '^Y'  redo
bindkey '^Z'  undo
bindkey '^['  vi-cmd-mode           # ESC (Escape)



## Taken from http://github.com/ohmyzsh/ohmyzsh/raw/master/lib/key-bindings.zsh
# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function _smkx() {
    echoti smkx
  }
  function _rmkx() {
    echoti rmkx
  }
  autoload -Uz add-zle-hook-widget
  add-zle-hook-widget zle-line-init   _smkx
  add-zle-hook-widget zle-line-finish _rmkx
fi

# vim: nowrap sw=0 ts=2 sts=2 et
