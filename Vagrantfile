# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"

  config.vm.hostname = "dev-arch"
  config.vm.network "private_network", ip: "192.168.56.10"

  config.vm.provision "shell", path: "provision.sh"
  # When re-enabling dotfiles in provision.sh, pass DOTFILES_REPO from the host:
  # config.vm.provision "shell",
  #   path: "provision.sh",
  #   env: {
  #     "DOTFILES_REPO" => ENV.fetch("DOTFILES_REPO", "https://github.com/YOURUSER/dotfiles.git"),
  #   }
end
