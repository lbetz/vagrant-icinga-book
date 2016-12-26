# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = { 'draco'  => {
            :box      => 'centos-7.3-x64-virtualbox',
            :url      => 'http://boxes.icinga.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000099',
            :net      => 'icinga-book.local',
          },
          'aquarius'  => {
            :box      => 'centos-7.3-x64-virtualbox',
            :url      => 'http://boxes.icinga.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000016',
            :memory   => '512',
            :net      => 'icinga-book.local',
          },
#          'carina'  => {
#            :box      => 'centos-7.3-x64-virtualbox',
#            :url      => 'http://boxes.icinga.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
#            :mac      => '020027000012',
#            :memory   => '1024',
#            :net      => 'icinga-book.local',
#          },
          'antlia'  => {
            :box      => 'centos-7.3-x64-virtualbox',
            :url      => 'http://boxes.icinga.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000212',
            :net      => 'icinga-book.net',
          },
          'gmw'  => {
            :box      => 'centos-7.3-x64-virtualbox',
            :url      => 'http://boxes.icinga.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000013',
            :net      => 'icinga-book.local',
          },
          'kmw'  => {
            :box      => 'centos-7.3-x64-virtualbox',
            :url      => 'http://boxes.icinga.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000213',
            :net      => 'icinga-book.net',
          },
          'sextans'  => {
            :box      => 'centos-7.3-x64-virtualbox',
            :url      => 'http://boxes.icinga.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000014',
            :net      => 'icinga-book.local',
          },
          'sagittarius'  => {
            :box      => 'centos-7.3-x64-virtualbox',
            :url      => 'http://boxes.icinga.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000214',
            :net      => 'icinga-book.net',
          },
#          'phoenix'  => {
#            :box      => 'dploeger/oracle-XE-11.2-x86_64',
#            :mac      => '020027000015',
#            :memory   => '1024',
#            :net      => 'icinga-book.local',
#          },
          'andromeda'  => {
            :box      => 'w2k12r2-x64-virtualbox',
            :url      => 'http://boxes.icinga.org/vagrant/private/w2k12r2.box',
            :mac      => '020027000022',
            :memory   => '1024',
            :net      => 'icinga-book.local',
            :gui      => true,
          },
          'sculptor'  => {
            :box      => 'centos-7.3-x64-virtualbox',
            :url      => 'http://boxes.icinga.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000211',
            :net      => 'icinga-book.net',
          },
          'fornax'  => {
            :box      => 'centos-7.3-x64-virtualbox',
            :url      => 'http://boxes.icinga.org/vagrant/centos/centos-7.2-x64-virtualbox.box',
            :mac      => '020027000011',
            :memory   => '512',
            :net      => 'icinga-book.local',
          },
        }

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  nodes.each_pair do |name, options|
    config.vm.define name do |node_config|
      node_config.vm.box = options[:box]
      node_config.vm.hostname = name
      node_config.vm.box_url = options[:url] if options[:url]
      node_config.vm.network :private_network, :adapter => 2, type: "dhcp"
      node_config.vm.provider :virtualbox do |vb|
        vb.linked_clone = true if Vagrant::VERSION =~ /^1.8/
        vb.name = name
        vb.gui = options[:gui]
        vb.customize ["modifyvm", :id,
          "--groups", "/Icinga Book/" + options[:net],
          "--memory", "256",
          "--audio", "none",
          "--usb", "on",
          "--usbehci", "off",
          "--nic2", "intnet",
          "--intnet2", options[:net],
          "--macaddress2", options[:mac],
        ]
        vb.memory = options[:memory] if options[:memory]
      end
      node_config.ssh.forward_agent = true
      node_config.vm.provision :shell,
          :path => 'scripts/pre-install.sh' if options[:box] != "w2k12r2-x64-virtualbox"
      node_config.vm.provision :shell,
          :path => 'scripts/pre-install.bat' if options[:box] == "w2k12r2-x64-virtualbox"
      node_config.vm.provision :puppet do |puppet|
        puppet.environment = "provision"
        puppet.environment_path = "puppet"
        puppet.hiera_config_path = "hiera.yaml"
        puppet.facter = {
          "domain" => options[:net],
          "fqdn"   => name + "." + options[:net],
        }
      end
    end
  end

  config.vm.define "draco" do |draco|
    draco.vm.network :private_network, :adapter => 2, ip: "172.16.1.254"
    draco.vm.network :private_network, :adapter => 3, ip: "172.16.2.254"
    draco.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--nic3", "intnet"]
      vb.customize ["modifyvm", :id, "--intnet3", "icinga-book.net" ]
    end
  end

#  config.vm.define "antlia" do |antlia|
#    antlia.vm.network "forwarded_port", guest: 80, host: 8080
#    antlia.vm.network "forwarded_port", guest: 443, host: 8443
#  end

#  config.vm.define "carina" do |carina|
#   carina.vm.synced_folder "./modules", "/etc/puppet/modules"
#   carina.vm.synced_folder "./modules.private", "/etc/puppet/environments/common"
#  end

  config.vm.define "fornax" do |fornax|
    fornax.vm.network :private_network, :adapter => 3, ip: "192.168.56.10"
  end

end
