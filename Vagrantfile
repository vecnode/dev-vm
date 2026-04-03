# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Official archlinux/archlinux has no active releases on Vagrant Cloud (all revoked);
  # generic/arch ships VirtualBox (and other providers) and is still Arch-based.
  config.vm.box = "generic/arch"

  config.vm.hostname = "dev-arch"
  config.vm.network "private_network", ip: "192.168.56.10"

  # VirtualBox: show the VM window on `vagrant up` (LightDM/XFCE after provision; TTY before).
  # Set vb.gui = false for headless; or open the window from VirtualBox Manager → Show.
  config.vm.provider "virtualbox" do |vb|
    vb.gui = true
    vb.name = "dev-arch"
  end

  config.vm.provision "shell",
    path: "provision.sh",
    env: {
      "DOTFILES_REPO" => ENV.fetch("DOTFILES_REPO", "https://github.com/vecnode/dotfiles.git"),
    }
end
