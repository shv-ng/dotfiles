
# widget
fcd-widget(){
  cd "$(fd --type d \
      --exclude target \
      --exclude build \
      --exclude node_modules \
      | fzf)"
}

zle -N fcd-widget

bindkey "^f" fcd-widget
bindkey -s "^p" 'tmux-sessionizer^M'

bindkey '^@' forward-word
