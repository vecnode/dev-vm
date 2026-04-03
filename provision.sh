#!/usr/bin/env bash
set -euo pipefail

# 1. Ensure basic tools inside the VM
if command -v pacman >/dev/null 2>&1; then
  # Small bootstrap only (before keyring + full sync). Upgrade the TLS/curl chain together or
  # pacman breaks on the next run:
  #   - openssl: new libngtcp2 needs OPENSSL_3.5.0 in libssl
  #   - libssh2: new libcurl needs libssh2_session_callback_set2
  sudo pacman -Sy --noconfirm openssl libssh2 git curl

  # Refresh signing keys before large installs. Without this, pacman may try to import keys
  # from a keyserver (often fails in NAT/VBox: "could not be looked up remotely").
  _pacman_gpg=/etc/pacman.d/gnupg/gpg.conf
  sudo install -d /etc/pacman.d/gnupg
  if [[ ! -f "$_pacman_gpg" ]] || ! grep -q '^keyserver ' "$_pacman_gpg" 2>/dev/null; then
    printf '%s\n' 'keyserver hkp://keyserver.ubuntu.com:80' | sudo tee -a "$_pacman_gpg" >/dev/null
  fi
  sudo pacman -Sy --noconfirm archlinux-keyring

  # 2. Lightweight graphical session: XFCE + LightDM (typical “small desktop” stack on Arch).
  #
  # A GUI on Arch *is* straightforward once the system matches the mirrors. Vagrant boxes are
  # frozen snapshots; installing ~200 current packages on top without upgrading the base hits
  # partial-upgrade bugs (e.g. gcc-libs split into libgcc/libstdc++). Full sync after a fresh
  # archlinux-keyring is the supported fix — same idea as `pacman -Syu` on a real machine.
  #
  # virtualbox-guest-utils-nox conflicts with virtualbox-guest-utils (X11); remove it first.
  sudo pacman -Rns --noconfirm virtualbox-guest-utils-nox 2>/dev/null || true

  sudo pacman -Syu --noconfirm

  mapfile -t _xfce < <(pacman -Sgq xfce4)
  sudo pacman -S --noconfirm --needed \
    "${_xfce[@]}" \
    lightdm \
    lightdm-gtk-greeter \
    ttf-dejavu \
    virtualbox-guest-utils

  sudo systemctl set-default graphical.target
  sudo systemctl enable lightdm.service
  sudo systemctl start lightdm.service

  # Match package expectations (avoids recurring "directory permissions differ" on polkit upgrades).
  sudo chmod 755 /usr/share/polkit-1/rules.d 2>/dev/null || true
elif command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y git curl
else
  echo "Unsupported package manager; install git and curl manually." >&2
  exit 1
fi

# 3. Dotfiles: clone https://github.com/vecnode/dotfiles (common + arch-linux) and run install.sh
#    as vagrant. Override: DOTFILES_REPO=... vagrant provision
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/vecnode/dotfiles.git}"

if [[ -d /home/vagrant/.dotfiles/.git ]]; then
  sudo -u vagrant git -C /home/vagrant/.dotfiles pull --ff-only
else
  sudo rm -rf /home/vagrant/.dotfiles
  sudo -u vagrant git clone "$DOTFILES_REPO" /home/vagrant/.dotfiles
fi

sudo -u vagrant bash -c 'cd /home/vagrant/.dotfiles && bash install.sh'
