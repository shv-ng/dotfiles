fcda(){
    cd "$(find -type d | fzf)"
}

fcd() {
    cd "$(fd --type d \
        --exclude .git \
        --exclude target \
        --exclude build \
        --exclude node_modules \
        | fzf)"
}

