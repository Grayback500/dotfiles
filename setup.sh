#!/bin/bash

# Hyprland
mkdir -p ~/.config/hypr
ln -sf ~/dotfiles/hyprland/* ~/.config/hypr/

# Doom Emacs
ln -sf ~/dotfiles/doom-emacs/* ~/.doom.d/

# Kitty
ln -sf ~/dotfiles/kitty/ ~/.config/kitty/
