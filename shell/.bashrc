#!/bin/bash

# Load env variables
source $HOME/.env

# Aliases
for f in $HOME/aliases/*; do
  source $f
done

# For any extra non committed bashrc bits
if [ -f $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi

# Custom
eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(zellij setup --generate-auto-start bash)"

# Show header
type fastfetch &>/dev/null && fastfetch
