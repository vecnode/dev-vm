#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get upgrade -y

# Guest video: prebuilt guest modules from Ubuntu repos (match host VB with ISO if needed).
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
  virtualbox-guest-x11 \
  greybird-gtk-theme \
  elementary-xfce-icon-theme \
  adwaita-icon-theme \
  gnome-themes-extra \
  gtk2-engines-murrine \
  gtk2-engines-pixbuf

# VirtualBox + XFCE: compositing / GL can misbehave; also seed a light-looking theme + wallpaper
# so the session does not look like a "broken black screen" (dark default + no backdrop).
sudo -u vagrant mkdir -p /home/vagrant/.config/xfce4/xfconf/xfce-perchannel-xml

sudo tee /home/vagrant/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml >/dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="use_compositing" type="bool" value="false"/>
    <property name="theme" type="string" value="Greybird"/>
  </property>
</channel>
EOF

sudo tee /home/vagrant/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml >/dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Greybird"/>
    <property name="IconThemeName" type="string" value="elementary-xfce"/>
  </property>
</channel>
EOF

# First bundled XFCE/Ubuntu backdrop so xfdesktop is not an empty black canvas.
_xfce_bg=""
for _d in /usr/share/xfce4/backdrops /usr/share/backgrounds/xfce; do
  [[ -d $_d ]] || continue
  _xfce_bg=$(find "$_d" -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.svg' \) 2>/dev/null | head -1)
  [[ -n $_xfce_bg ]] && break
done
[[ -n $_xfce_bg ]] || _xfce_bg="/usr/share/xfce4/backdrops/xfce-blue.jpg"

sudo tee /home/vagrant/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml >/dev/null <<EOF
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop-screen0" type="empty">
    <property name="monitor0" type="empty">
      <property name="workspace0" type="empty">
        <property name="last-image" type="string" value="${_xfce_bg}"/>
        <property name="image-style" type="int" value="5"/>
      </property>
    </property>
  </property>
</channel>
EOF

sudo chown -R vagrant:vagrant /home/vagrant/.config

sudo touch /home/vagrant/.xprofile
if ! grep -q 'LIBGL_ALWAYS_SOFTWARE' /home/vagrant/.xprofile 2>/dev/null; then
  echo 'export LIBGL_ALWAYS_SOFTWARE=1' | sudo tee -a /home/vagrant/.xprofile >/dev/null
fi
sudo chown vagrant:vagrant /home/vagrant/.xprofile

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
