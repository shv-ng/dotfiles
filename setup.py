import argparse

from dotfile_utils import backup, copy, sync, update, push

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Manage your dotfiles.")
    parser.add_argument(
        "--backup",
        action="store_true",
        help="Backup existing files/directories to ~/backup/config.",
    )
    parser.add_argument(
        "--update",
        action="store_true",
        help="Update dotfiles repository with local config files.",
    )
    parser.add_argument(
        "--copy",
        action="store_true",
        help="Copy dotfiles from repository to ~/.config/",
    )
    parser.add_argument(
        "--sync",
        action="store_true",
        help="Sync dotfiles with GitHub repository",
    )
    parser.add_argument(
        "--push",
        metavar="MESSAGE",
        type=str,
        nargs="?",
        const="Update dotfiles",
        help="Push dotfiles to GitHub repository with an optional commit"
        ' message. Defaults to "Update dotfiles".',
    )
    args = parser.parse_args()

    if args.backup:
        backup()
    if args.update:
        update()
    if args.copy:
        copy()
    if args.sync:
        sync()
    if args.push is not None:
        push(args.push)
