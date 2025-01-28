import shutil
from pathlib import Path

# Open the file containing the list of paths to copy
with open("files_to_copy.txt") as f:
    for path in f:
        path = path.strip()  # Remove any leading or trailing whitespace

        if not path:  # Skip empty lines
            continue

        # Expand the user's home directory in the source path
        src = Path(path).expanduser()

        # Replace "~/" with "~/dotfiles/" to map to the destination structure
        dist_str = path.replace("~/", "~/dotfiles/")
        dist = Path(dist_str).expanduser()  # Expand the destination path

        if src.is_dir():
            # Copy the entire directory to the destination
            shutil.copytree(src, dist, dirs_exist_ok=True)
        else:
            # Ensure the parent directory of the file exists
            parent = Path("/".join(dist_str.split("/")[:-1])).expanduser()
            parent.mkdir(exist_ok=True, parents=True)

            # Copy the file to the destination
            shutil.copy2(src, parent)
