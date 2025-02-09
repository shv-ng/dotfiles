nv() {
  if [ -d "./.venv" ]; then
    echo "Activating virtual environment from ./.venv..."
    source ./.venv/bin/activate
  fi
  GITIGNORE_FILE=".gitignore"
  ENTRY="Session.vim"

  # Check if .gitignore exists
  if [ ! -f "$GITIGNORE_FILE" ]; then
    echo "$GITIGNORE_FILE not found. Creating one..."
    echo "$ENTRY" > "$GITIGNORE_FILE"
    echo "Added $ENTRY to $GITIGNORE_FILE."
    exit 0
  fi
  # Check if entry already exists
  if grep -Fxq "$ENTRY" "$GITIGNORE_FILE"; then
    echo "$ENTRY is already in $GITIGNORE_FILE."
  else
    echo "$ENTRY" >> "$GITIGNORE_FILE"
    echo "Added $ENTRY to $GITIGNORE_FILE."
  fi
  nvim
}
