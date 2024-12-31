#!/bin/bash

# Missing: neovim stow btop htop fastfetch

echo "Install Rust CLIs"
cargo install zoxide eza starship zellij bat duf sd yazi-fm yazi-cli

echo "install Go CLIs"
go install github.com/jesseduffield/lazygit@latest github.com/junegunn/fzf@latest

echo "Running stow..."
cd stow
stow -v -R * --target=$HOME
cd ..
