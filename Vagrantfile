# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.define "docker01" do |docker|
    docker.vm.hostname = "docker01.docker"

    docker.vm.network :forwarded_port, id: "ssh", guest: 22, host: 2201
    docker.vm.network "private_network", ip: "192.168.33.101"

    docker.vm.synced_folder ".", "/vagrant"

    docker.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end

    docker.vm.provision "shell", path: "provision.sh", env: {"ROLE" => "master"}
  end

  config.vm.define "docker02" do |docker|
    docker.vm.hostname = "docker02.docker"

    docker.vm.network :forwarded_port, id: "ssh", guest: 22, host: 2202
    docker.vm.network "private_network", ip: "192.168.33.102"

    docker.vm.synced_folder ".", "/vagrant"

    docker.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end

    docker.vm.provision "shell", path: "provision.sh"
  end

  config.vm.define "docker03" do |docker|
    docker.vm.hostname = "docker03.docker"

    docker.vm.network :forwarded_port, id: "ssh", guest: 22, host: 2203
    docker.vm.network "private_network", ip: "192.168.33.103"

    docker.vm.synced_folder ".", "/vagrant"

    docker.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end

    docker.vm.provision "shell", path: "provision.sh", env: {"ROLE" => "lastnode"}
  end

end
