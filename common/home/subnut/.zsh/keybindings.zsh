## Allow fwd-i-search by unbinding ^S from stty stop
stty stop undef


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


## Keybinds
function bindkey {
  local keymap
  for keymap in emacs viins vicmd; do
    builtin bindkey -M $keymap "$@"
  done
}
[[ -n "${terminfo[khome]}" ]] && bindkey "${terminfo[khome]}" beginning-of-line       # [Home]
[[ -n "${terminfo[kend]}"  ]] && bindkey "${terminfo[kend]}"  end-of-line             # [End]
[[ -n "${terminfo[kcbt]}"  ]] && bindkey "${terminfo[kcbt]}"  reverse-menu-complete   # Shift+[Tab]
[[ -n "${terminfo[kdch1]}" ]] && bindkey "${terminfo[kdch1]}" delete-char             # [Delete]
unfunction bindkey


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
