# dev-vm

Vagrant project: bring up an Arch Linux VM, clone your dotfiles, and run `./install` inside the guest.

## Setup / reproduce

```sh
git clone https://github.com/vecnode/dev-vm.git
cd dev-vm

# Point at your dotfiles repo (edit provision.sh or pass at provision time)
export DOTFILES_REPO="https://github.com/vecnode/dotfiles.git"

vagrant up
vagrant ssh
```

To re-run provisioning after changing `DOTFILES_REPO` or your dotfiles:

```sh
DOTFILES_REPO="https://github.com/vecnode/dotfiles.git" vagrant provision
```

If you start from an empty folder instead of this repo:

```sh
mkdir dev-vm && cd dev-vm
vagrant init archlinux/archlinux
# Then add the Vagrantfile and provision.sh from this project (or merge the provision block and files).
vagrant up
```

