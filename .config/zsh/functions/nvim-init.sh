nv() {
  if [ -d "./.venv" ]; then
    echo "Activating virtual environment from ./.venv..."
    source ./.venv/bin/activate
    nvim
  fi

}
