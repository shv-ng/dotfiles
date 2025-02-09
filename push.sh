#!/bin/bash

# Copy from ~/.config to ~/dotfiles

# Remove existing dotfiles
rm -rf .config
rm -rf .mozilla

# Python script to copy from .config to dotfiles/config
python3 copy_to_dotfiles.py

# Remove pycache
rm -rf __pycache__/

# Get list of changed files
git status --porcelain | while read -r status file; do
    # Extract file status
    change_type=$(echo "$status" | awk '{print $1}')
    
    # Generate commit message based on status
    case "$change_type" in
        M) commit_msg="Modified $file" ;;
        A) commit_msg="Added $file" ;;
        D) commit_msg="Deleted $file" ;;
        "??") commit_msg="Untracked $file" ;; # Optional, can ignore if not needed
        *) commit_msg="Updated $file" ;;
    esac

    # Add, commit, and push
    git add "$file"
    git commit -m "$commit_msg"
done

# Push all committed changes
git push origin "$(git branch --show-current)"

echo "All changes committed and pushed successfully!"

