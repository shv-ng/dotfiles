#!/bin/bash

# Copy from ~/.config to ~/dotfiles

# Remove existing dotfiles
rm -rf .config
rm -rf .mozilla

# Python script to copy from .config to dotfiles/config
python3 copy_to_dotfiles.py

# Remove pycache
rm -rf __pycache__/

# Initialize arrays for each type of change
modified=()
added=()
deleted=()
untracked=()

# Get the list of changed files
while read -r status file; do
    change_type=$(echo "$status" | awk '{print $1}')
    
    case "$change_type" in
        M) modified+=("$file") ;;
        A) added+=("$file") ;;
        D) deleted+=("$file") ;;
        "??") untracked+=("$file") ;;
    esac

    # Add file to staging
    git add "$file"
done < <(git status --porcelain)

# Construct commit message
commit_msg=""

[[ ${#added[@]} -gt 0 ]] && commit_msg+="Added: ${added[*]}; "
[[ ${#modified[@]} -gt 0 ]] && commit_msg+="Modified: ${modified[*]}; "
[[ ${#deleted[@]} -gt 0 ]] && commit_msg+="Deleted: ${deleted[*]}; "
[[ ${#untracked[@]} -gt 0 ]] && commit_msg+="Untracked: ${untracked[*]}; "

# Remove trailing semicolon and space
commit_msg=${commit_msg%"; "}

# Commit and push if there are changes
if [[ -n "$commit_msg" ]]; then
    git commit -m "$commit_msg"
    git push origin "$(git branch --show-current)"
else
    echo "No changes to commit."
fi

