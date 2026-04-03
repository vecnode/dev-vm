#!/usr/bin/env bash
# Shared by arch-linux and ubuntu-linux provision scripts (mounted at /vagrant in the guest).
set -euo pipefail

DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/vecnode/dotfiles.git}"

if [[ -d /home/vagrant/.dotfiles/.git ]]; then
  sudo -u vagrant git -C /home/vagrant/.dotfiles pull --ff-only
else
  sudo rm -rf /home/vagrant/.dotfiles
  sudo -u vagrant git clone "$DOTFILES_REPO" /home/vagrant/.dotfiles
fi

# install.sh may default to ~/dotfiles (no dot); we clone to ~/.dotfiles.
sudo -u vagrant bash -c 'export REPO_DIR=/home/vagrant/.dotfiles; cd "$REPO_DIR" && bash install.sh'
