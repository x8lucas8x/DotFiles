#!/bin/bash

brew install fzf zellij neovim starship stow bat lazygit yazi \
  btop htop zsh
brew install --cask kitty

echo "Running stow..."
stow -S */
