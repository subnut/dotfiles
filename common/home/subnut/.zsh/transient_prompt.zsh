## Transient prompt
function _transient_prompt-zle-line-finish {
  RPROMPT=
  PROMPT=$PROMPT_PROMPT' '
  zle reset-prompt
}
function _transient_prompt-zle-line-init {
  function _transient_prompt-zle-line-init {
      set_prompt
      PROMPT=$'\n'$PROMPT
      zle reset-prompt
      set_prompt
  }
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-init   _transient_prompt-zle-line-init
add-zle-hook-widget zle-line-finish _transient_prompt-zle-line-finish

function _transient_prompt-send-break {
    _transient_prompt-zle-line-finish
    zle .send-break
}
trap '_transient_prompt-send-break' INT
[[ ${widgets[send-break]} = builtin ]] &&
    zle -N send-break _transient_prompt-send-break


# vim: sw=0 ts=4 sts=4 et
