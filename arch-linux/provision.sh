#!/usr/bin/env bash
set -euo pipefail

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

# Lightweight graphical session: XFCE + LightDM.
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

sudo chmod 755 /usr/share/polkit-1/rules.d 2>/dev/null || true
