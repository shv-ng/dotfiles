# Dotfiles

This repository contains my personal dotfiles and a utility script to manage them. The setup script provides functionality to back up, update, copy, sync, and push dotfiles with ease.

## Getting Started

### For First-Time Setup

1. Clone the Repository:
    ```bash
    git clone https://github.com/ShivangSrivastava/dotfiles
    cd dotfiles
    ```

2. Backup your existing configurations:
    ```bash
    python setup.py --backup
    ```
    This will save your current configuration files to `~/backup/config`.

3. Copy the repository dotfiles to your configuration directory:
    ```bash
    python setup.py --copy
    ```

### Updating with the Latest Repository

1. Sync the repository with the remote GitHub repository:
    ```bash
    python setup.py --sync
    ```

2. Backup your updated configurations:
    ```bash
    python setup.py --backup
    ```

3. Copy the latest dotfiles from the repository to your configuration directory:
    ```bash
    python setup.py --copy
    ```

## Usage
The `setup.py` script provides several options to manage your dotfiles. Run the script with the appropriate arguments based on your requirement.

```bash
usage: setup.py [-h] [--backup] [--update] [--copy] [--sync] [--push [MESSAGE]]

Manage your dotfiles.

options:
  -h, --help        Show this help message and exit.
  --backup          Backup existing files/directories to ~/backup/config.
  --update          Update the dotfiles repository with local config files.
  --copy            Copy dotfiles from the repository to ~/.config/.
  --sync            Sync dotfiles with the GitHub repository.
  --push [MESSAGE]  Push dotfiles to the GitHub repository with an optional commit message (default: "Update dotfiles").
```

## Customizing Your Own Dotfiles Repository

Feel free to fork this repository to create your own custom dotfiles setup. Follow these steps:

1. Clone your forked repository:
    ```bash
    git clone <your-repo-url>
    cd <your-repo-name>
    ```

2. Add your configuration files to the `FILES_TO_COPY` list in `dotfiles_utils.py` and replace `REPO_URL` with `<your-repo-url>`.

3. Push your custom dotfiles to your repository:
    ```bash
    python setup.py --push "Initial commit"
    ```

## Directory Structure
- `dotfiles/`: Contains the configuration files to be managed.
- `setup.py`: Script for managing the dotfiles.

## Prerequisites
- Python 3.x
- Git installed and configured

## Contributing
Feel free to fork the repository and submit pull requests for improvements or additional functionality.

## License
This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
