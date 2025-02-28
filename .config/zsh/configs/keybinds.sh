
# widget
fcd-widget(){
  fcd
}
fcda-widget(){
  fcda
}

zle -N fcd-widget
zle -N fcda-widget

bindkey "^f" fcd-widget
bindkey -s "^t" 'tmux-sessionizer^M'
bindkey "^[^f" fcda-widget

bindkey '^@' forward-word
