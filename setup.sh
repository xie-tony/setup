#!/bin/bash

non_sudo="sudo -u $SUDO_USER"

# Update apt-get
apt-get update
apt-get -y upgrade

# Install git
apt-get install -y git

# Install zsh
apt-get install -y zsh
$non_sudo bash ./zsh.sh

# Dotfile stuff
$non_sudo bash ./dotfile.sh

# Linuxbrew
$non_sudo bash ./brew.sh

# Ocaml stuff
apt-get install -y opam
$non_sudo bash ./ocaml.sh

