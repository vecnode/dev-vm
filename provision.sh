#!/usr/bin/env bash
set -euo pipefail

# Re-enable with Vagrantfile env when using dotfiles:
# DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/YOURUSER/dotfiles.git}"

# 1. Ensure basic tools inside the VM
if command -v pacman >/dev/null 2>&1; then
  sudo pacman -Syu --noconfirm git curl
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y git curl
else
  echo "Unsupported package manager; install git and curl manually." >&2
  exit 1
fi

# 2. Clone dotfiles and run install entrypoint (bypassed for now)
# if [[ -d /home/vagrant/.dotfiles/.git ]]; then
#   git -C /home/vagrant/.dotfiles pull --ff-only
# else
#   rm -rf /home/vagrant/.dotfiles
#   git clone "$DOTFILES_REPO" /home/vagrant/.dotfiles
# fi
#
# chown -R vagrant:vagrant /home/vagrant/.dotfiles
#
# sudo -u vagrant bash -c 'cd /home/vagrant/.dotfiles && ./install'
