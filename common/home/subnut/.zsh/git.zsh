# vim:set et ts=2 sw=0 sts=2:
export GPG_TTY=$(tty)
my_git ()
{
  (
    unset  DISPLAY   # make gpg-agent use pinentry-curses instead of pinentry-gtk-2
    export SSH_AUTH_SOCK="$_SSH_AUTH_SOCK"
    export SSH_AGENT_PID="$_SSH_AGENT_PID"
    unset _SSH_AUTH_SOCK
    unset _SSH_AGENT_PID
    git "$@"      # <- this line is the reason of the NOTE regarding the `alias git`
  )
}
alias git=my_git  # NOTE: this alias MUST come after the my_git function definition
alias g=git
alias ga='git add'
alias gaa='git add --all'
alias gaav='git add --all --verbose'
alias gd='git diff --patience'
alias gds='gd --staged'
alias gdh='gd HEAD'
alias gdh1='gd HEAD~1 HEAD'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gp='git push'
gpf () { echo 'DO NOT USE --force' >&2; echo 'Use --force-with-lease' >&2; return 1; }
alias gpfwl='git push --force-with-lease'
alias gpull='git pull'
gcm () { DISPLAY= git commit    -m "$*" }
gcma() { DISPLAY= git commit -a -m "$*" }
alias gst='git status'
alias gsw='git switch'

## Taken from snippet OMZ:plugins/git
#alias glg='git log --stat'
#alias glgp='git log --stat -p'
#alias glgg='git log --graph'
#alias glgga='git log --graph --decorate --all'
#alias glgm='git log --graph --max-count=10'
#alias glo='git log --oneline --decorate'
#alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
#alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
#alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
#alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
#alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
#alias glog='git log --oneline --decorate --graph'
#alias gloga='git log --oneline --decorate --graph --all'
