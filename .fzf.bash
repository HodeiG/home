# Auto-completion
# ---------------
source "/usr/share/bash-completion/completions/fzf"

# Key bindings
# ------------
source "/usr/share/doc/fzf/examples/key-bindings.bash"

export FZF_DEFAULT_COMMAND='rg --files --hidden --unrestricted'
export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --bind "ctrl-d:page-down,ctrl-u:page-up"'

