# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = 'centos65'
  config.vm.box_url = 'https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box'
  config.vm.network :private_network, ip: '192.168.50.12'
  config.vm.hostname = 'localhost'
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '1024']
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'off']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'off']
  end
  config.berkshelf.enabled = true
  config.vm.provision :chef_solo do |chef|
    chef.log_level = :debug
    chef.cookbooks_path = %w(cookbooks site-cookbooks)
    chef.run_list = %w(movabletype)
    chef.json = {
      mysql: {
        server_root_password: ''
      },
      yum: {
        epel: {
          enabled: false
        }
      }
    }
  end
  config.vm.provision :shell, inline: "if [ ! $(grep single-request-reopen /etc/resolv.conf) ]; then echo 'options single-request-reopen' >> /etc/resolv.conf && service network restart; fi"
  config.omnibus.chef_version = '11.10.4'
  config.ssh.forward_agent = true
end
