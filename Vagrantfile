# -*- mode: ruby -*-
# vi: set ft=ruby :

# Multi-machine: `vagrant up arch`, `vagrant up ubuntu`, or `vagrant up` for both.
# Dotfiles run as a second provisioner (uploaded by Vagrant) — do not rely on /vagrant mount.

Vagrant.configure("2") do |config|
  _dotfiles = {
    "DOTFILES_REPO" => ENV.fetch("DOTFILES_REPO", "https://github.com/vecnode/dotfiles.git"),
  }

  config.vm.define "arch", primary: true do |arch|
    arch.vm.box = "generic/arch"
    arch.vm.hostname = "dev-arch"
    arch.vm.network "private_network", ip: "192.168.56.10"
    arch.vm.provision "shell", path: "arch-linux/provision.sh", env: _dotfiles
    arch.vm.provision "shell", path: "shared/mask-vboxclient-autostart.sh"
    arch.vm.provision "shell", path: "shared/dotfiles.sh", env: _dotfiles
    arch.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.name = "dev-arch"
    end
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "ubuntu/jammy64"
    ubuntu.vm.hostname = "dev-ubuntu"
    ubuntu.vm.network "private_network", ip: "192.168.56.11"
    ubuntu.vm.provision "shell", path: "ubuntu-linux/provision.sh", env: _dotfiles
    ubuntu.vm.provision "shell", path: "shared/mask-vboxclient-autostart.sh"
    ubuntu.vm.provision "shell", path: "shared/dotfiles.sh", env: _dotfiles
    ubuntu.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.name = "dev-ubuntu"
    end
  end
end
