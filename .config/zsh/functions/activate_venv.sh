activate_venv(){
    if [[ -f "$(pwd)/.venv/bin/activate" ]]; then
        source $(pwd)/.venv/bin/activate

    fi
}
