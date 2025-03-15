
# completions
fpath+=~/.zfunc
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select

eval "$(fzf --zsh)"
