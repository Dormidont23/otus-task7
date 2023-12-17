# -*- mode: ruby -*-
# vim: set ft=ruby : vsa
Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  config.vm.box_version = "2004.01"
  config.vm.provider "virtualbox" do |v|
  config.vm.synced_folder "./", "/vagrant", disabled: true
  v.memory = 4096
  v.cpus = 4
end
  config.vm.define "otus-task7" do |vv|
    vv.vm.hostname = "otus-task7"
    vv.vm.provision "shell", path: "script.sh"
  end
# config.vm.provision "file", source: "./nginx.spec", destination: "/tmp/"
end
