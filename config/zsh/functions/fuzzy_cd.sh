fcda(){
    cd "$(find -type d | fzf)"
}

fcd() {
    cd "$(find . -type d \
        -not -path '*/.*' \
        -not -path '*/target*' \
        -not -path '*/build*' \
        -not -path '*/node_modules*' \
        | fzf)"
}
