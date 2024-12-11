import shutil
from pathlib import Path

config_path = Path.home() / ".config"
dotfiles_repo_path = Path.home() / "dotfiles" / "config"

files_to_copy = [
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
]


def update_dotfiles():
    for file_name in files_to_copy:
        src = config_path / file_name
        dest = dotfiles_repo_path / file_name

        if src.exists():
            if src.is_dir():
                shutil.copytree(src, dest, dirs_exist_ok=True)
                print(f"Copied directory: {src} -> {dest}")
            else:
                shutil.copy2(src, dest)
                print(f"Copied file: {src} -> {dest}")
        else:
            print(f"Source does not exist: {src}")


if __name__ == "__main__":
    update_dotfiles()
