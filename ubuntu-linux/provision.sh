#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get upgrade -y

# Guest video: use packages from Ubuntu repos (prebuilt modules for -generic kernels).
# There is no `virtualbox-guest-dkms` in default Jammy repos; DKMS builds are only needed if
# host VirtualBox and guest modules diverge — then install Guest Additions from the host ISO.
sudo apt-get install -y \
  git \
  curl \
  xorg \
  xserver-xorg \
  xserver-xorg-core \
  dbus-x11 \
  dbus-user-session \
  xfce4 \
  xfce4-goodies \
  xfdesktop4 \
  lightdm \
  lightdm-gtk-greeter \
  fonts-dejavu-core \
  virtualbox-guest-utils \
  virtualbox-guest-x11

# Greeter OK but black desktop after login: common in VirtualBox + XFCE when compositing / GL
# path misbehaves. Disable xfwm4 compositing and prefer software GL for the vagrant session.
sudo -u vagrant mkdir -p /home/vagrant/.config/xfce4/xfconf/xfce-perchannel-xml
sudo tee /home/vagrant/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml >/dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="use_compositing" type="bool" value="false"/>
  </property>
</channel>
EOF
sudo chown -R vagrant:vagrant /home/vagrant/.config

sudo touch /home/vagrant/.xprofile
if ! grep -q 'LIBGL_ALWAYS_SOFTWARE' /home/vagrant/.xprofile 2>/dev/null; then
  echo 'export LIBGL_ALWAYS_SOFTWARE=1' | sudo tee -a /home/vagrant/.xprofile >/dev/null
fi
sudo chown vagrant:vagrant /home/vagrant/.xprofile

# Pick XFCE at the greeter (matches /usr/share/xsessions/xfce.desktop).
sudo install -d /etc/lightdm/lightdm.conf.d
sudo tee /etc/lightdm/lightdm.conf.d/50-vagrant-xfce.conf >/dev/null <<'EOF'
[Seat:*]
user-session=xfce
EOF

sudo systemctl set-default graphical.target
sudo systemctl enable lightdm.service

sudo modprobe vboxguest 2>/dev/null || true
sudo modprobe vboxsf 2>/dev/null || true
sudo modprobe vboxvideo 2>/dev/null || true

sudo systemctl restart lightdm.service
