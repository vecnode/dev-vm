#!/usr/bin/env bash
# Stops XFCE from launching VBoxClient helpers at login — avoids "VBoxClient: Failure
# waiting for event" notification spam when guest additions don't match the host VirtualBox.
# Trade-off: no host clipboard / seamless resize integration until you match versions (e.g.
# Devices → Insert Guest Additions CD) or remove the overrides in ~/.config/autostart/.

# Need to look further

set -euo pipefail

sudo -u vagrant mkdir -p /home/vagrant/.config/autostart

while IFS= read -r -d '' _f; do
  [[ -f $_f ]] || continue
  _base=$(basename "$_f")
  sudo -u vagrant tee "/home/vagrant/.config/autostart/$_base" >/dev/null <<'EOF'
[Desktop Entry]
Hidden=true
EOF
done < <(find /etc/xdg/autostart -maxdepth 1 -type f \( -iname '*vbox*' -o -iname '*VBox*' \) -print0 2>/dev/null || true)
