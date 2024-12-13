#!/bin/bash

brew install fzf zellij neovim starship stow bat lazygit yazi \
  btop htop zsh eza zoxide duf fastfetch
brew install --cask kitty font-fira-code-nerd-font \
  font-cascadia-code-nf font-cascadia-mono-nf

echo "Running stow..."
stow -S */
