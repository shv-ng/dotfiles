import shutil
from pathlib import Path

CONFIG_DIR = Path("config")

with open("files_to_copy.txt") as f:
    for path in f:
        src = Path(path)
        if src.is_dir():
            shutil.copytree(src, CONFIG_DIR, dirs_exist_ok=True)
        else:
            shutil.copy2(src, CONFIG_DIR)
