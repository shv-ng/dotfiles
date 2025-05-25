#!/bin/bash

# Copy from ~/.config to ~/dotfiles

# Remove existing dotfiles
rm -rf .config .mozilla .local

# Python script to copy from .config to dotfiles/config
python3 make_copy.py

# Remove pycache
rm -rf __pycache__/

# Let me do remaining with lazygit
lazygit
