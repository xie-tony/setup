#!/bin/bash

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
git clone --bare https://github.com/xie-tony/dotfiles.git $HOME/.cfg

# Backup the defaults
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}

config checkout
config config --local status.showUntrackedFiles no
