#!/bin/bash

sudo pacman -S fzf zellij neovim starship stow bat lazygit yazi \
  btop htop kitty wezterm yay zsh ttf-firacode-nerd ttf-cascadia-code-nerd \
  ttf-cascadia-mono-nerd eza zoxide duf fastfetch sd

echo "Running stow..."
cd stow
stow -v -R * --target=$HOME
cd ..
