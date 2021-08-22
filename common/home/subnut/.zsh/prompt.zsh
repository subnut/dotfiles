## We need to run commands inside our prompts
setopt PROMPT_SUBST

## Helper function to allow running commands inside $PROMPT without changing $?
function prompt_exec {
    local exitcode=$?
    "$@"
    return $exitcode
}

## Array of colors to use in prompts
typeset -gA prompt_colors
if [[ ${terminfo[colors]} -eq 256 ]]; then
    prompt_colors[red]=196
    prompt_colors[grey]=244
    prompt_colors[green]=34
else
    prompt_colors[red]=1
    prompt_colors[grey]=7
    prompt_colors[green]=2
fi

# PROMPT_PROMPT='%F{'$${prompt_colors[grey]}'}$%f'
# PROMPT_PROMPT='%B%(?.%F{green}.%F{red})%(!.#.$)%f%b'

PROMPT_PROMPT=
PROMPT_PROMPT=${PROMPT_PROMPT}'%B'
PROMPT_PROMPT=${PROMPT_PROMPT}'%(?.%F{'${prompt_colors[green]}'}.%F{'${prompt_colors[red]}'})'
PROMPT_PROMPT=${PROMPT_PROMPT}'%(!.#.$)'
PROMPT_PROMPT=${PROMPT_PROMPT}'%f'
PROMPT_PROMPT=${PROMPT_PROMPT}'%b'
PROMPT_PROMPT=${PROMPT_PROMPT}' '

function set_prompt {
    PROMPT=''
    PROMPT=${PROMPT}'%B%~%b'
    PROMPT=${PROMPT}'$(prompt_exec echoti hpa $((COLUMNS)))'
    PROMPT=${PROMPT}'%(?..$(prompt_exec echoti cub ${#?})%B%F{'${prompt_colors[red]}'}%?%f%b)'
    PROMPT=${PROMPT}$'\n'
    PROMPT=${PROMPT}${PROMPT_PROMPT}
}
set_prompt


## Show execution time in RPROMPT
zmodload zsh/datetime
typeset -ga _epochtime_precmd
typeset -ga _epochtime_preexec
function _exectime {
    # Define this function AFTER the very first prompt has been shown
    # Otherwise, it shows a bogus value in the RPROMPT, since
    # _epochtime_preexec is not defined yet
    function _exectime {
        RPROMPT="%f"
        if [[ ${_epochtime_preexec[1]} -eq ${_epochtime_precmd[1]} ]]; then
            local nanosec=$(( _epochtime_precmd[2] - _epochtime_preexec[2] ))
            local sec="$(( nanosec / 1000000000.0 ))"
            RPROMPT="${sec:0:5}s$RPROMPT"   # 0.xxx -- 5 chars
        else
            local sec
            sec=$(( _epochtime_precmd[1] - _epochtime_preexec[1] ))
            RPROMPT="$(( sec % 60 ))s$RPROMPT"
            [[ $(( sec /= 60 )) -gt 0 ]] &&
                RPROMPT="$(( sec % 60 ))m $RPROMPT"     # mins
            [[ $(( sec /= 60 )) -gt 0 ]] &&
                RPROMPT="$(( sec % 24 ))h $RPROMPT"     # hours
            [[ $(( sec /= 60 )) -gt 0 ]] &&
                RPROMPT="$(( sec % 24 ))d $RPROMPT"     # days
        fi
        RPROMPT="%F{${prompt_colors[grey]}}$RPROMPT"
    }
}
function _exectime_precmd   {
    if [[ _epochtime_precmd[1] -lt _epochtime_preexec[1] ]] ||
        [[ _epochtime_precmd[2] -lt _epochtime_preexec[2] ]]
    then _epochtime_precmd=($epochtime)
    fi
}
function _exectime_preexec  {
    _epochtime_preexec=($epochtime)
}
preexec_functions+=_exectime_preexec
precmd_functions+=_exectime_precmd
precmd_functions+=_exectime


## Show warning if buffer empty
EMPTY_BUFFER_WARNING_TEXT='Buffer empty!'
zle -N accept-line
function accept-line {
    if [[ $#BUFFER -ne 0 ]]
    then zle .accept-line
    else
        # NOTE: The next 3 commands are important when the cursor is at the
        # last line of the terminal
        echoti cud1
        echoti cuu1
        print -P -f '%s' "$PROMPT_PROMPT"
        echoti sc
        echoti cud 1
        echoti hpa 0
        print -P -f "%s$EMPTY_BUFFER_WARNING_TEXT%s" "%F{${prompt_colors[red]}}" '%f'
        echoti ed
        echoti rc

        # Create function that resets warning
        function _empty_buffer_warning_reset {
            unfunction _empty_buffer_warning_reset
            echoti sc
            echoti cud 1
            echoti hpa 0
            printf "%${#EMPTY_BUFFER_WARNING_TEXT}s"
            echoti ed
            echoti rc
        }

        # Reset the warning if any character is typed
        zle -N self-insert
        function self-insert {
            unfunction self-insert
            zle .self-insert
            zle -A .self-insert self-insert
            _empty_buffer_warning_reset
        }
    fi
}


## Show vi mode
#function _vi_mode_show_mode {
#    echoti sc
#    echoti cud 1
#    echoti hpa 0
#    echoti el
#    (( ${#1} )) && print -P -f "%s$1%s" '%B' '%b'
#    echoti rc
#}
#
#function _vi_mode-visual-mode { _vi_mode_show_mode VISUAL; zle .visual-mode }
#zle -N {,_vi_mode-}visual-mode
#function _vi_mode-vi-replace { _vi_mode_show_mode REPLACE; zle .vi-replace }
#zle -N {,_vi_mode-}vi-replace
#function _vi_mode-overwrite-mode { _vi_mode_show_mode OVERWRITE; zle .overwrite-mode }
#zle -N {,_vi_mode-}overwrite-mode
#
#function _vi_mode-zle-keymap-select {
#    local text
#    [[ $KEYMAP = vicmd ]] && text=NORMAL
#    [[ $KEYMAP = viins ]] && text=INSERT
#    _vi_mode_show_mode $text
#}
#autoload -Uz add-zle-hook-widget
#add-zle-hook-widget {,_vi_mode-zle-}keymap-select


## Transient prompt
function _transient_prompt-zle-line-finish {
  RPROMPT=
  PROMPT=$PROMPT_PROMPT
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
[[ ${widgets[send-break]} = builtin ]] &&
    zle -N send-break _transient_prompt-send-break

_transient_prompt-precmd() { trap '_transient_prompt-send-break' INT }
_transient_prompt-preexec() { trap - INT }
precmd_functions+=_transient_prompt-precmd
preexec_functions+=_transient_prompt-preexec


# vim: sw=0 ts=4 sts=4 et
