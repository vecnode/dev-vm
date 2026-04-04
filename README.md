# dev-vm

Vagrant multi-machine project: 
- **Arch** (`generic/arch`)
- **Ubuntu** (`ubuntu/jammy64`)  

Each with XFCE + LightDM and dotfiles.


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

