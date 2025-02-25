nv() {
  if [ -d "./.venv" ]; then
    source ./.venv/bin/activate
  fi

  GITIGNORE_FILE=".gitignore"
  ENTRY="Session.vim"

  # Check if .gitignore exists
  if [ ! -f "$GITIGNORE_FILE" ]; then
    echo "$ENTRY" > "$GITIGNORE_FILE"
    exit 0
  fi
  if grep -Fxq "$ENTRY" "$GITIGNORE_FILE"; then
  else
    echo "$ENTRY" >> "$GITIGNORE_FILE"
  fi
  nvim
}
