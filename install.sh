#!/usr/bin/sh

NVIM_MINIMALIST=~/.config/nvim-minimalist
export NVIM_MINIMALIST

rm -rf $NVIM_MINIMALIST

mkdir -p $NVIM_MINIMALIST/share
mkdir -p $NVIM_MINIMALIST/share/nvim/session
mkdir -p $NVIM_MINIMALIST/nvim

stow --restow --target=$NVIM_MINIMALIST/nvim .

alias nvmm='XDG_DATA_HOME=$NVIM_MINIMALIST/share XDG_CACHE_HOME=$NVIM_MINIMALIST XDG_CONFIG_HOME=$NVIM_MINIMALIST nvim'
