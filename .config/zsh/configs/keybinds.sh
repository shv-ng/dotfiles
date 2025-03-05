
# widget
fcd-widget(){
  cd "$(fd --type d \
      --exclude target \
      --exclude build \
      --exclude node_modules \
      | fzf)"
}
fcda-widget(){
  cd "$(fd --full-path -H --type d | fzf)"
}

zle -N fcd-widget
zle -N fcda-widget

bindkey "^f" fcd-widget
bindkey -s "^t" 'tmux-sessionizer^M'
bindkey "^[^f" fcda-widget

bindkey '^@' forward-word
