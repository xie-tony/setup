#!/bin/bash

non_sudo="su -p -s "/bin/bash" $SUDO_USER -c"

# Pull dotfile from repo
installDotfile () {
    local config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
    git clone --bare https://github.com/xie-tony/dotfiles.git $HOME/.cfg

    # Backup the defaults
    mkdir -p .config-backup && \
    $config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
    xargs -I{} mv $HOME/{} $HOME/.config-backup/{}

    $config checkout
    $config config --local status.showUntrackedFiles no
}

# Use linuxbrew to download some stuff that's not in apt-get
installBrew () {
    mkdir /home/linuxbrew/.linuxbrew/bin
    ln -s /home/linuxbrew/.linuxbrew/Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

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
chsh $SUDO_USER -s $(which zsh)

# Dotfile stuff
$non_sudo "installDotfile"

# Linuxbrew
# Manunal install since I can't get around sudo password
git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew
USER_GROUP=$($non_sudo "id -gn")
chown -R "$SUDO_USER:$USER_GROUP" /home/linuxbrew/.linuxbrew

$non_sudo "installBrew"

# Ocaml stuff
apt-get install -y software-properties-common
add-apt-repository -y ppa:avsm/ppa
apt-get update
apt-get install -y opam
# Required for core
apt-get install -y m4 gcc make
$non_sudo "installOcaml"

