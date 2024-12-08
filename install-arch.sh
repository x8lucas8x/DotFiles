#!/bin/bash

sudo pacman -S fzf zellij neovim starship stow bat lazygit yazi \
  btop htop kitty yay zsh

echo "Running stow..."
stow -S */
