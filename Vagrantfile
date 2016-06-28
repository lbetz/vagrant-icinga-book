# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = { 'draco'  => {
            :box      => 'centos-7.2-x64-virtualbox',
            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000099',
          },
          'aquarius'  => {
            :box      => 'centos-7.2-x64-virtualbox',
            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000016',
            :memory   => '1024',
          },
          'antlia'  => {
            :box      => 'centos-7.2-x64-virtualbox',
            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000212',
          },
          'carina'  => {
            :box      => 'centos-7.2-x64-virtualbox',
            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000012',
          },
          'gmw'  => {
            :box      => 'centos-7.2-x64-virtualbox',
            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000013',
          },
#          'sextans'  => {
#            :box      => 'centos-7.2-x64-virtualbox',
#            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
#            :mac      => '020027000014',
#          },
          'phoenix'  => {
            :box      => 'centos-7.2-x64-virtualbox',
            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000015',
          },
#          'andromeda'  => {
#            :box      => 'w2k12r2',
#            :url      => 'http://boxes.netways.org/vagrant/windows/w2k12r2-x64-virtualbox.box',
#            :mac      => '020027000022',
#          },
          'kmw'  => {
            :box      => 'centos-7.2-x64-virtualbox',
            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000213',
          },
#          'sagittarius'  => {
#            :box      => 'centos-7.2-x64-virtualbox',
#            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
#            :mac      => '020027000214',
#          },
          'sculptor'  => {
            :box      => 'centos-7.2-x64-virtualbox',
            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000211',
          },
          'fornax'  => {
            :box      => 'centos-7.2-x64-virtualbox',
            :url      => 'http://boxes.netways.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000011',
            :memory   => '1024',
          },
        }

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  nodes.each_pair do |name, options|
    config.vm.define name do |node_config|
      node_config.vm.box = options[:box]
      node_config.vm.hostname = name
      node_config.vm.box_url = options[:url]
      node_config.vm.network :private_network, :adapter => 2, type: "dhcp"
      node_config.vm.provider :virtualbox do |vb|
        vb.linked_clone = true if Vagrant::VERSION =~ /^1.8/
        vb.name = name
        vb.gui = false
        vb.customize ["modifyvm", :id,
          "--groups", "/Icinga Book",
          "--memory", "384",
          "--audio", "none",
          "--usb", "on",
          "--usbehci", "off",
          "--nic2", "intnet",
          "--intnet2", "intnet",
          "--macaddress2", options[:mac],
        ]
        vb.memory = options[:memory] if options[:memory]
      end
      node_config.ssh.forward_agent = true
      node_config.vm.provision :shell,
          :path => 'scripts/pre-install.sh'
      node_config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "manifests"
        puppet.module_path = [ "modules.private", "modules" ]
        puppet.hiera_config_path = "hiera.yaml"
      end
    end
  end

#  config.vm.define "andromeda" do |andromeda|
#    andromeda.vm.provision :shell,
#      :path => 'scripts/pre-install.bat'
#    andromeda.vm.provider :virtualbox do |vb|
#      vb.customize ["modifyvm", :id, "--memory", "1024"]
#    end
#  end

  config.vm.define "draco" do |draco|
    draco.vm.network :private_network, :adapter => 2, ip: "172.16.1.254"
    draco.vm.network :private_network, :adapter => 3, ip: "172.16.2.254"
    draco.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--nic3", "intnet"]
      vb.customize ["modifyvm", :id, "--intnet3", "intnet2" ]
    end
  end

  config.vm.define "antlia" do |antlia|
    antlia.vm.network :private_network, :adapter => 2, type: "dhcp"
    antlia.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
      vb.customize ["modifyvm", :id, "--intnet2", "intnet2" ]
    end
  end

  config.vm.define "kmw" do |kmw|
    kmw.vm.network :private_network, :adapter => 2, type: "dhcp"
    kmw.vm.provider :virtualbox do |vb|
      vb.customize [ "modifyvm", :id,
        "--nic2", "intnet",
        "--intnet2", "intnet2",
      ]
    end
  end

  config.vm.define "sculptor" do |sculptor|
    sculptor.vm.network :private_network, :adapter => 2, type: "dhcp"
    sculptor.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--nic2", "intnet"]
      vb.customize ["modifyvm", :id, "--intnet2", "intnet2" ]
    end
  end

  config.vm.define "aquarius" do |aquarius|
    config.vm.network :forwarded_port, guest: 8080, host: 8080, id: "tomcat", auto_correct: true
  end

  config.vm.define "fornax" do |fornax|
    fornax.vm.network :private_network, :adapter => 3, ip: "192.168.56.10"
#    fornax.vm.network :public_network, :adapter => 4, type: "dhcp"
#    fornax.vm.provider :virtualbox do |vb|
#      vb.customize ["modifyvm", :id,
#        "--hostonlyadapter3", "vboxnet0",
#        "--bridgeadapter4", "en5: Thunderbolt-Ethernet",
#      ]
#    end
    fornax.vm.synced_folder "~/puppetcode", "/root/puppetcode"
  end

end
