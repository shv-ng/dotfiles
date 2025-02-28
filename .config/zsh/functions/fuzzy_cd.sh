
fcda(){
   cd "$(fd --full-path -H --type d | fzf)"
}

fcd() {
    cd "$(fd --type d \
        --exclude target \
        --exclude build \
        --exclude node_modules \
        | fzf)"
}

