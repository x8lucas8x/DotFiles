#!/bin/bash

# Oh My ZSH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

skip_global_compinit=1

source $ZSH/oh-my-zsh.sh

# Load env variables
source $HOME/.env

# Aliases
for f in $HOME/aliases/*; do
  source $f
done

# For any extra non committed zshrc bits
if [ -f $HOME/.zshrc.local ]; then
  source $HOME/.zshrc.local
fi

# Custom
eval "$(starship init zsh)"
source <(fzf --zsh)
eval "$(zoxide init zsh)"

# Show header
type fastfetch &> /dev/null && fastfetch
