#!/bin/bash

non_sudo="su $SUDO_USER -c"

# Pull dotfile from repo
installDotfile () {
    local config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
    git clone --bare https://github.com/xie-tony/dotfiles.git $HOME/.cfg

    # Backup the defaults
    mkdir -p .config-backup && \
    $config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
    xargs -I{} mv {} .config-backup/{}

    $config checkout
    $config config --local status.showUntrackedFiles no
}

# Use linuxbrew to download some stuff that's not in apt-get
installBrew () {
    CI=1 /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    /home/linuxbrew/.linuxbrew/bin/brew install\
        fzf ripgrep
}

installOcaml () {
    # It's already in the shell file copied from dotfile
    opam init -n
    eval $(opam env)
    opam switch create 4.10.0
    eval $(opam env)
    opam update

    opam install -y \
        utop core async \
        merlin ocamlformat \
        ocaml-lsp-server
}

installZsh () {
    sh -c "$(curl -fsSL \
        https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" \
        --keep-zshrc\
        --unattended
}

export -f installDotfile installBrew \
	  installOcaml installZsh

# Update apt-get
apt-get update
apt-get -y upgrade

# Install git
apt-get install -y git

# Install zsh
apt-get install -y zsh
$non_sudo "installZsh"
chsh -s $SUDO_USER /usr/bin/zsh

# Dotfile stuff
$non_sudo "installDotfile"

# Linuxbrew
$non_sudo "installBrew"

# Ocaml stuff
apt-get install -y software-properties-common
add-apt-repository -y ppa:avsm/ppa
apt-get update
apt-get install -y opam
$non_sudo "installOcaml"

