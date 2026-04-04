# dev-vm

Vagrant multi-machine project: 
- **Arch** (`generic/arch`)
- **Ubuntu** (`ubuntu/jammy64`)  

Each with XFCE + LightDM and dotfiles.

**VBoxClient warnings:** If guest additions don’t match your host VirtualBox, Linux can flood notifications (`Failure waiting for event`). This repo runs `shared/mask-vboxclient-autostart.sh` so those helpers don’t autostart (quiet desktop; no host clipboard / seamless resize until you install matching Guest Additions from **Devices → Insert Guest Additions CD** and remove the overrides under `~/.config/autostart/` if you want them back).

## Setup

Install virtualbox

```sh
git clone https://github.com/vecnode/dev-vm.git
cd dev-vm

# spin up
vagrant up arch
vagrant up ubuntu

# ssh
vagrant ssh arch
vagrant ssh ubuntu

# destroy
vagrant destroy -f arch
vagrant destroy -f ubuntu
```

Override dotfiles URL:

```sh
DOTFILES_REPO=https://github.com/you/dotfiles.git vagrant up arch
```

