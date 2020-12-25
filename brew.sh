#!/bin/bash

# Use linuxbrew to download some stuff that's not in apt-get
CI=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install fzf ripgrep
