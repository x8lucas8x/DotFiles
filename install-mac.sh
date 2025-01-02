#!/bin/bash

brew install fzf zellij neovim starship stow bat lazygit yazi \
  btop htop zsh eza zoxide duf fastfetch sd
brew install --cask kitty font-fira-code-nerd-font \
  font-cascadia-code-nf font-cascadia-mono-nf \
  nikitabobko/tap/aerospace

echo "Running stow..."
cd stow
stow -v -R * --target=$HOME
cd ..
