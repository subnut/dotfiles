# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
#
#    _fzf_compgen_path() {
#      fd --hidden --follow --exclude ".git" . "$1"
#    }
#
#
# Use fd to generate the list for directory completion
#
#    _fzf_compgen_dir() {
#      fd --type d --hidden --follow --exclude ".git" . "$1"
#    }
#

export FZF_DEFAULT_OPTS="--ansi \
  --color light \
  --preview-window 'right:60%:hidden:wrap' \
  --bind ctrl-v:toggle-preview \
  --margin 1,2"
