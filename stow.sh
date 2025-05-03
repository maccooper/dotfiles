#!/usr/bin/env bash
set -e

cd "$HOME/.dotfiles"
stow aerospace
stow fish
stow git
stow local
stow nvim
stow tmux
