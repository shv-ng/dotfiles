import shutil
from pathlib import Path
import subprocess

CONFIG_PATH = Path.home() / ".config"
DOTFILES_REPO_PATH = Path.home() / "dotfiles" / "config"
BACKUP_PATH = Path.home() / "backup" / "config"

FILES_TO_COPY = [
    ".zshrc",
    "dunst",
    "fastfetch",
    "fish",
    "htop",
    "hypr",
    "kitty",
    "ml4w",
    "nvim",
    "rofi",
    "starship",
    "tmux",
    "waybar",
    "zsh",
    "Code/User/snippets",
    "Code/User/settings.json",
    "Code/User/keybindings.json",
]


def backup():
    """Backup existing files/directories to ~/backup/config."""
    BACKUP_PATH.mkdir(parents=True, exist_ok=True)
    for file_name in FILES_TO_COPY:
        src = CONFIG_PATH / file_name
        dest = BACKUP_PATH / file_name

        if src.exists():
            if src.is_dir():
                shutil.copytree(src, dest, dirs_exist_ok=True)
                print(f"Backed up directory: {src} -> {dest}")
            else:
                shutil.copy2(src, dest)
                print(f"Backed up file: {src} -> {dest}")
        else:
            print(f"Source does not exist for backup: {src}")


def update():
    """Update dotfiles repository with local config files."""
    for file_name in FILES_TO_COPY:
        src = CONFIG_PATH / file_name
        dest = DOTFILES_REPO_PATH / file_name

        if src.exists():
            if src.is_dir():
                shutil.copytree(src, dest, dirs_exist_ok=True)
                print(f"Copied directory: {src} -> {dest}")
            else:
                shutil.copy2(src, dest)
                print(f"Copied file: {src} -> {dest}")
        else:
            print(f"Source does not exist: {src}")


def copy():
    """Copy dotfiles from repository to ~/.config/."""
    for file_name in FILES_TO_COPY:
        src = DOTFILES_REPO_PATH / file_name
        dest = CONFIG_PATH / file_name

        if src.exists():
            if src.is_dir():
                shutil.copytree(src, dest, dirs_exist_ok=True)
                print(f"Copied directory to config: {src} -> {dest}")
            else:
                shutil.copy2(src, dest)
                print(f"Copied file to config: {src} -> {dest}")
        else:
            print(f"Source does not exist in repo: {src}")


def sync():
    """Sync dotfiles with GitHub repository."""
    REPO_URL = "https://github.com/ShivangSrivastava/dotfiles"
    try:
        subprocess.run(
            [
                "yes",
                "|",
                "rm",
                "-rf",
                "./*",
                "./.*",
            ],
            check=True,
        )
        print(f"Cloning repository from {REPO_URL} to current directory...")
        subprocess.run(
            [
                "git",
                "clone",
                REPO_URL,
                ".",
            ],
            check=True,
        )
        print("Repository cloned and current directory replaced successfully.")

    except subprocess.CalledProcessError as e:
        print(f"Git operation failed: {e}")


def push(message):
    """Push dotfiles to GitHub repository."""
    try:
        # Remove __pycache__ from the index first
        subprocess.run(
            ["git", "rm", "-r", "--cached", "__pycache__/"],
            check=True,
        )
    except subprocess.CalledProcessError:
        print("__pycache__ was not being tracked or already removed.")

    try:
        # Stage all changes
        subprocess.run(
            ["git", "add", "."],
            check=True,
        )

        # Commit with the provided message
        subprocess.run(
            ["git", "commit", "-m", message],
            check=True,
        )

        # Push changes
        subprocess.run(
            ["git", "push"],
            check=True,
        )
        print("Dotfiles synced with GitHub successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Git operation failed: {e}")
