
# Fuzzy cd
zle -N fcd
zle -N fcda

# ctrl+f
bindkey "^f" fcd 
bindkey "^[^f" fcda

bindkey '^@' forward-word
