autoload -Uz is-at-least

function _p9k_set_prompt() {
  set_prompt
}

_p9k_trapint() {
  zle && _p9k_on_widget_zle-line-finish int
  return 0
}

_p9k_precmd() {
  unset _p9k__line_finished
  TRAPINT() { _p9k_trapint; return $(( $1 + 128 ));}
}

function _p9k_reset_prompt() {
  if (( __p9k_reset_state != 1 )) && zle && [[ -z $_p9k__line_finished ]]; then
    __p9k_reset_state=0
    zle .reset-prompt
    zle -R
  fi
}


function _p9k_on_widget_zle-line-finish() {
  (( $+_p9k__line_finished )) && return

  local P9K_PROMPT=transient

  _p9k__line_finished=

  if [[ -n $_p9k_transient_prompt ]]; then
    __p9k_reset_state=2
  fi

  if [[ $1 == int ]]; then
    if (( !_p9k__restore_prompt_fd )); then
      sysopen -o cloexec -ru _p9k__restore_prompt_fd /dev/null
      zle -F $_p9k__restore_prompt_fd _p9k_restore_prompt
    fi
  fi

  if (( __p9k_reset_state == 2 )); then
    RPROMPT= PROMPT=$_p9k_transient_prompt _p9k_reset_prompt
  fi

  _p9k__line_finished='%{%}'
  PROMPT=$'\n'${PROMPT#$'\n'}
}

function _p9k_on_widget_send-break() {
  _p9k_on_widget_zle-line-finish int
}


function _p9k_widget_hook() {
  (( _p9k__restore_prompt_fd )) && _p9k_restore_prompt $_p9k__restore_prompt_fd
  if [[ $1 == clear-screen ]]; then
    PROMPT=${PROMPT#$'\n'}
    _p9k_reset_prompt
    zle .clear-screen
  fi
  __p9k_reset_state=1
  local pat idx var
  (( $+functions[_p9k_on_widget_$1] )) && _p9k_on_widget_$1
  (( __p9k_reset_state == 2 )) && _p9k_reset_prompt
  __p9k_reset_state=0
}

function _p9k_widget() {
  local f=${widgets[_p9k_orig_$1]:-}
  local -i res
  [[ -z $f ]] || {
    zle _p9k_orig_$1 -- "${@:2}"
    res=$?
  }
  [[ $CONTEXT != start ]] || {
    _p9k_widget_hook "$@"
  }
  return res
}

function _p9k_widget_send-break() {
  [[ $CONTEXT != start ]] || {
    _p9k_widget_hook send-break "$@"
  }
  local f=${widgets[_p9k_orig_send-break]:-}
  [[ -z $f ]] || zle _p9k_orig_send-break -- "$@"
}

function _p9k_wrap_widgets() {
  (( __p9k_widgets_wrapped )) && return
  typeset -gir __p9k_widgets_wrapped=1
  local -a widget_list
    local -aU widget_list=(
      zle-line-finish
      zle-keymap-select
      overwrite-mode
      vi-replace
      visual-mode
      visual-line-mode
      deactivate-region
      clear-screen
      send-break
    )
  local widget
  for widget in $widget_list; do
    if (( ! $+functions[_p9k_widget_$widget] )); then
      functions[_p9k_widget_$widget]='_p9k_widget '${(q)widget}' "$@"'
    fi
    if [[ $widget == zle-* &&
          $widgets[$widget] == user:azhw:* &&
          $functions[add-zle-hook-widget] ]]; then
      add-zle-hook-widget $widget _p9k_widget_$widget
    else
      zle -A $widget _p9k_orig_$widget 2>/dev/null
      zle -N $widget _p9k_widget_$widget
    fi
  done
}

function _p9k_restore_prompt() {
  zle -F $1
  exec {1}>&-
  _p9k__restore_prompt_fd=0

  unset _p9k__line_finished
  _p9k_set_prompt
  zle .reset-prompt
  zle -R
}

_p9k_do_nothing() { true; }

_p9k_setup() {
  _p9k_transient_prompt=$PROMPT_TRANSIENT
  _p9k_set_prompt
  _p9k_wrap_widgets
  typeset -ga precmd_functions=(_p9k_do_nothing $precmd_functions _p9k_precmd)
}

# 0  -- reset-prompt not blocked
# 1  -- reset-prompt blocked and not needed
# 2  -- reset-prompt blocked and needed
typeset -gi __p9k_reset_state

autoload -Uz add-zsh-hook
zmodload zsh/system
_p9k_setup

# vim:ft=zsh:
