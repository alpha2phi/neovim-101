#!/usr/bin/sh

NVIM_101=~/.config/nvim-101
export NVIM_101

alias nvmm='XDG_DATA_HOME=$NVIM_101/share XDG_CACHE_HOME=$NVIM_101 XDG_CONFIG_HOME=$NVIM_101 nvim'

nvmm
