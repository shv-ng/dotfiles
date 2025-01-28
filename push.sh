
# Copy from ~/.config to ~/dotfiles
#
# Remove existing dotfiles
rm -rf config

# Python script to copy from .config to dotfiles/config
python3 copy_to_dotfiles.py


# Remove pycache
rm -rf __pycache__/

# Push to github
git add .
git commit -m "$1"
git push

