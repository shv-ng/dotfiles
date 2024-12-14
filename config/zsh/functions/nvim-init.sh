nv() {
  if [ -d "./.venv" ]; then
    echo "Activating virtual environment from ./.venv..."
    source ./.venv/bin/activate
  fi

  echo "source session.vim
autocmd QuitPre * mksession! session.vim" > ./.nvimrc && nvim
}
