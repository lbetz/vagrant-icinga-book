# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
VAGRANT_REQUIRED_LINKED_CLONE_VERSION = "1.8.0"

DEFAULT_BOOK_CHAPTER = "2"

nodes = {
  'aquarius' => {
    :mac    => '020027000016',
    :memory => '512',
    :net    => 'icinga-book.local',
  },
  'carina' => {
    :mac    => '020027000012',
    :memory => '512',
    :net    => 'icinga-book.local',
  },
  'antlia' => {
    :mac    => '020027000212',
    :net    => 'icinga-book.net',
    :forwarded => {
      '443' => '8443',
      '80'  => '8080',
    },
  },
  'gmw' => {
    :mac    => '020027000013',
    :net    => 'icinga-book.local',
  },
  'kmw' => {
    :mac    => '020027000213',
    :net    => 'icinga-book.net',
  },
  'sextans' => {
    :mac    => '020027000014',
    :net    => 'icinga-book.local',
  },
  'sagittarius' => {
    :mac    => '020027000214',
    :net    => 'icinga-book.net',
  },
  'sculptor'  => {
    :mac      => '020027000211',
    :net      => 'icinga-book.net',
  },
  'fornax' => {
    :mac    => '020027000011',
    :memory => '512',
    :net    => 'icinga-book.local',
    :forwarded => {
      '80'  => '8000',
    },
  },
}

networks = {
  'icinga-book.local' => '172.16.1.0',
  'icinga-book.net'   => '172.16.2.0',
}


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "bento/centos-7.2"
  config.ssh.forward_agent = true


  if ENV['BOOK_CHAPTER']
    book_chapter = ENV['BOOK_CHAPTER']
  else
    book_chapter = DEFAULT_BOOK_CHAPTER
  end

  config.vm.define "draco" do |node|
    node.vm.hostname = "draco"
    node.vm.host_name = "draco.icinga-book.local"

    node.vm.network :private_network, ip: "172.16.1.254"
    node.vm.network :private_network, ip: "172.16.2.254"

    node.vm.provision :shell, :path => 'scripts/pre-install.sh'
    node.vm.provision :puppet do |puppet|
      puppet.environment_path = "puppet/environments"
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.facter = {
	"chapter" => book_chapter,
        "domain"  => "icinga-book.local",
        "fqdn"    => "draco.icinga-book.local",
      }
    end 

    node.vm.provider :parallels do |prl, override|
      prl.name = "draco"
      prl.linked_clone = true
      prl.check_guest_tools = false
      prl.update_guest_tools = false
      prl.memory = 384
    end

    node.vm.provider :virtualbox do |vb, override|
      vb.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new(VAGRANT_REQUIRED_LINKED_CLONE_VERSION)
      vb.name = "draco"
      vb.gui = false
      vb.customize ["modifyvm", :id,
        "--groups", "/Icinga Book/icinga-book.local",
        "--audio", "none",
        "--usb", "on",
        "--usbehci", "off",
        "--nic2", "intnet",
        "--intnet2", "icinga-book.local",
        "--nic3", "intnet",
        "--intnet3", "icinga-book.net",
      ]
      vb.memory = 512
      override.vm.network :private_network, :adapter => 2, ip: "172.16.1.254", virtualbox__intnet: "icinga-book.local"
      override.vm.network :private_network, :adapter => 3, ip: "172.16.2.254", virtualbox__intnet: "icinga-book.net"
    end
  end


  nodes.each_pair do |name, options|

    config.vm.define name do |node|
      # defaults
      options[:memory] = 384 unless options[:memory]

      node.vm.hostname = name
      node.vm.host_name = name + "." + options[:net]

      node.vm.network :private_network, ip: networks[options[:net]], type: "dhcp"

      node.vm.provider :parallels do |prl, override|
        prl.name = name
        prl.linked_clone = true
        prl.check_guest_tools = false
        prl.update_guest_tools = false
        prl.customize [ "set", :id, "--device-set", "net1", "--mac", options[:mac] ]
        prl.memory = options[:memory]
      end

      node.vm.provider :virtualbox do |vb, override|
        vb.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new(VAGRANT_REQUIRED_LINKED_CLONE_VERSION)
        vb.name = name
        vb.gui = false
        vb.customize ["modifyvm", :id,
          "--groups", "/Icinga Book/" + options[:net],
          "--audio", "none",
          "--usb", "on",
          "--usbehci", "off",
          "--nic2", "intnet",
          "--intnet2", options[:net],
        ]
        vb.memory = options[:memory]
        override.vm.network :private_network, :adapter => 2, type: "dhcp", virtualbox__intnet: options[:net]
      end

      if options[:forwarded]
        options[:forwarded].each_pair do |guest, local|
          node.vm.network "forwarded_port", guest: guest, host: local
        end
      end

      node.vm.provision :shell, :path => 'scripts/pre-install.sh'
      node.vm.provision :puppet do |puppet|
        puppet.environment_path = "puppet/environments"
        puppet.hiera_config_path = "puppet/hiera.yaml"
        puppet.facter = {
	  "chapter" => book_chapter,
          "domain"  => options[:net],
          "fqdn"    => name + "." + options[:net],
        }
      end
    end
  end

end
