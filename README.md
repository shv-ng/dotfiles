# Dotfiles

A collection of configuration files for my development environment.

## Quick Setup

Keep it simple, stupid (KISS).

```bash
sudo pacman -S git stow
git clone https://github.com/ShivangSrivastava/dotfiles
cd dotfiles
make stow
```

## Requirements

- `git` - Version control
- `stow` - Symlink farm manager

## What's Included

This repository contains configuration files for various tools and applications. The dotfiles are organized to work with GNU Stow for easy deployment and management.

## Usage

The `stow .` command will create symlinks from your home directory to the configuration files in this repository. This allows you to keep your dotfiles in version control while having them appear in their expected locations.

To remove the symlinks:

```bash
make unstow
```

## License

These dotfiles are provided as-is. Use at your own discretion.
