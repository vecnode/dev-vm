# dev-vm

Vagrant project: bring up an Arch Linux VM.

## Setup / reproduce

```sh
git clone https://github.com/vecnode/dev-vm.git
cd dev-vm

# Point at your dotfiles repo (edit provision.sh or pass at provision time)
export DOTFILES_REPO="https://github.com/vecnode/dotfiles.git"

vagrant up
vagrant ssh
```


