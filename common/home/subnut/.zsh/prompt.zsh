## We need to run commands inside our prompts
setopt PROMPT_SUBST

## Helper function to allow running commands inside $PROMPT without changing $?
function prompt_exec {
    local exitcode=$?
    "$@"
    return $exitcode
}

## Helper function to print something with prompt expansion
function prompt_print {
    print -n -- "${(%)*}"
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

function prompt_prompt {
    local prompt
    prompt=
    if (( ${#1} )) && [[ $1 = transient ]]
    then
        prompt+="%F{${prompt_colors[grey]}}"
        prompt+='%(!.#.$)'
        prompt+='%f'
    else
        prompt+='%B'
        prompt+='%(?.%F{'${prompt_colors[green]}'}.%F{'${prompt_colors[red]}'})'
        prompt+='%(!.#.$)'
        prompt+='%f'
        prompt+='%b'
    fi
    prompt+=' '
    print -n -- "$prompt"
}

function set_prompt {
    PROMPT=
    PROMPT=${PROMPT}'%B%~%b'
    PROMPT=${PROMPT}'$(prompt_exec echoti hpa $((COLUMNS)))'
    PROMPT=${PROMPT}'%(?..$(prompt_exec echoti cub ${#?})%B%F{'${prompt_colors[red]}'}%?%f%b)'
    PROMPT=${PROMPT}$'\n'
    PROMPT=${PROMPT}$(prompt_prompt)
}
set_prompt

# function shorten_prompt {
#     RPROMPT=
#     PROMPT=$(prompt_prompt transient)
# }
PROMPT_TRANSIENT=$(prompt_prompt transient)


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
EMPTY_BUFFER_WARNING_COLOR=${prompt_colors[red]}
zle -N accept-line
function accept-line {
    if [[ $#BUFFER -ne 0 ]]
    then zle .accept-line
    else
        echoti cud1
        # The next two lines MUST NOT BE INTERCHANGED
        prompt_print "$(prompt_prompt)"
        echoti cuu1
        echoti sc
        echoti cud 1
        echoti hpa 0
        prompt_print "%F{$EMPTY_BUFFER_WARNING_COLOR}"$EMPTY_BUFFER_WARNING_TEXT'%f'
        echoti ed
        echoti rc
        # For the meaning of cud1,ed,hpa,... see terminfo(5)

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
#    (( ${#1} )) && prompt_print '%B'$1'%b'
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



return
## Transient prompt
# See: https://reddit.com/r/zsh/comments/k3ckmi/standalone_version_of_p10ks_transient_prompt
function _transient_prompt-zle-line-finish {
    shorten_prompt
    zle reset-prompt
    _transient_prompt_del_TRAPINT
}
function _transient_prompt-zle-line-init {
    function _transient_prompt-zle-line-init {
        set_prompt
        PROMPT=$'\n'$PROMPT
        zle reset-prompt
    }
}
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-init   _transient_prompt-zle-line-init
add-zle-hook-widget zle-line-finish _transient_prompt-zle-line-finish


# Remove leading space from $PROMPT when clear-screen
zle -N clear-screen _transient_prompt-clear-screen
function _transient_prompt-clear-screen {
    PROMPT=${PROMPT#$'\n'}
    zle .clear-screen
}


# Trap SIGINT
function _transient_prompt_add_TRAPINT {
    TRAPINT() { _transient_prompt-zle-line-finish; return $(( $1 + 128 )); }
}
function _transient_prompt_del_TRAPINT {
    (( ${+functions[TRAPINT]} )) && unfunction TRAPINT
}
precmd_functions+=_transient_prompt_add_TRAPINT
# preexec_functions+=_transient_prompt_del_TRAPINT  # Already in _transient_prompt-zle-line-finish


# interactive search
zle -N zle-isearch-update
function zle-isearch-update {
    _transient_prompt_del_TRAPINT
    zle -N self-insert
    function self-insert {
        _transient_prompt_add_TRAPINT
        unfunction self-insert
        zle .self-insert
        zle -A .self-insert self-insert
    }
}


###############  HERE BE DRAGONS  ###############
#get_stty() {
#    typeset -A stty;
#    local IFS='='
#    stty -a < $TTY | while read -d ';' entry
#    do (( ! ${#entry:/*=*/} )) && () { stty[${1// /}]=${2// /} }  ${=entry//$'\n'/}
#    done
#}; get_stty


#zle -N history-incremental-search-forward
#zle -N history-incremental-search-backward
#function history-incremental-search-forward {
#    unfunction TRAPINT
#    zle -w .history-incremental-search-forward "$BUFFER"
#    prompt_exec _transient_prompt_add_TRAPINT
#}
#function history-incremental-search-backward {
#    unfunction TRAPINT
#    trap 'trap - INT; sleep 1 && kill -INT $$' INT
#    zle .history-incremental-search-backward "$BUFFER"
#    prompt_exec _transient_prompt_add_TRAPINT
#}

# TODO: inside _transient_prompt_isearch_interrupted, add some code that makes
# CTRL-R CTRL-C behave as it does on `PROMPT='%? %% ' zsh -f`
#eval '
#zle-isearch-update() {
#    bindkey -M main '${stty[intr]}' _transient_prompt_isearch_interrupted
#    '${functions[zle-isearch-update]}'
#    stty intr undef <> $TTY
#}
#_transient_prompt_isearch_interrupted() {
#    bindkey -M main -r "'${stty[intr]}'"
#    stty intr "'${stty[intr]}'" <> $TTY
#}
#zle-isearch-exit() {
#    bindkey -M main -r "'${stty[intr]}'"
#    '${functions[zle-isearch-exit]}'
#    stty intr "'${stty[intr]}'" <> $TTY
#}
#'
#zle -N zle-isearch-update
#zle -N zle-isearch-exit
#zle -N _transient_prompt_isearch_interrupted

#unset stty

# vim: sw=0 ts=4 sts=4 et
