#!/usr/bin/sh

NVIM_101=~/.config/nvim-101
export NVIM_101

rm -rf "$NVIM_101"

mkdir -p "$NVIM_101"/share
mkdir -p "$NVIM_101"/share/nvim/session
mkdir -p "$NVIM_101"/nvim

stow --restow --target="$NVIM_101"/nvim .

alias nv101='XDG_DATA_HOME=$NVIM_101/share XDG_CACHE_HOME=$NVIM_101 XDG_CONFIG_HOME=$NVIM_101 nvim'
