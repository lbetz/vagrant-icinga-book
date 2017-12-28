# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"
VAGRANT_REQUIRED_LINKED_CLONE_VERSION = "1.8.0"

DEFAULT_BOOK_CHAPTER = "2"

require 'yaml'


# Provisioning module
module Vagrant
  module Config
    module V2
      class Root
        def book_provision(facter, os)
          if os == "windows"
            vm.provision :shell, :path => 'scripts/pre-install.bat'
          else
            vm.provision :shell, :path => 'scripts/pre-install.sh'
          end
          vm.provision :puppet do |puppet|
            if os == "windows"
              puppet.environment_path = "puppet/environments.windows"
            else
              puppet.environment_path = "puppet/environments"
            end
            puppet.hiera_config_path = "puppet/hiera.yaml"
            puppet.facter = facter
          end
        end
      end
    end
  end
end


# Load configuration, machines and networks
ConfigValues = YAML.load_file(File.dirname(File.expand_path(__FILE__)) + "/config.yaml")

if ENV['BOOK_CHAPTER']
  book_chapter = ENV['BOOK_CHAPTER']
else
  book_chapter = DEFAULT_BOOK_CHAPTER
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  ConfigValues['machines'].each_pair do |name, options|
    # defaults
    options[:os] = "linux" unless options[:os]
    options[:memory] = 384 unless options[:memory]
    options[:domain] = options[:net].keys.first unless options[:domain]

    config.vm.define name do |node|
      # base boxes
      if options[:os] == "windows"
        config.vm.box = "jacqinthebox/windowsserver2016"
        #config.ssh.insert_key = false
      else
        config.vm.box = "bento/centos-7.4"
        config.ssh.forward_agent = true
      end

      node.vm.hostname = name
      node.vm.host_name = name + "." + options[:domain] if options[:os] != "windows"

      node.book_provision( {'domain' => options[:domain], 'fqdn' => name + "." + options[:domain], 'chapter' => book_chapter}, options[:os] )

      if options[:forwarded]
        options[:forwarded].each_pair do |guest, local|
          node.vm.network "forwarded_port", guest: guest, host: local
        end
      end

      node.vm.provider :parallels do |prl, override|
        prl.name = name
        prl.linked_clone = true
        prl.check_guest_tools = false
        prl.update_guest_tools = false

        i=0 # create internal network intrfaces
        prl_customize = []
        options[:net].each_pair do |nic, attrs| i=i+1
          prl_customize.concat([ "net#{i}", "--mac", "#{attrs[:mac]}" ]) if attrs[:mac]
          if attrs[:ip]
            override.vm.network :private_network, ip: attrs[:ip]
          else
            override.vm.network :private_network, ip: ConfigValues['networks'][nic][:address], type: "dhcp"
          end
        end

        prl.customize [ "set", :id, "--device-set" ].concat(prl_customize) unless prl_customize.empty?
        prl.memory = options[:memory]
      end

      node.vm.provider :virtualbox do |vb, override|
        vb.linked_clone = true if Gem::Version.new(Vagrant::VERSION) >= Gem::Version.new(VAGRANT_REQUIRED_LINKED_CLONE_VERSION)
        vb.name = name
        vb.gui = false

        i=1 # create internal network interfaces
        vb_customize = []
        options[:net].each_pair do |nic, attrs| i=i+1
          vb_customize.concat([ "--nic#{i}", "intnet", "--intnet#{i}", nic ])
          vb_customize.concat([ "--macaddress#{i}", "#{attrs[:mac]}" ]) if attrs[:mac]
          if attrs[:ip]
            override.vm.network :private_network, :adapter => i, ip: attrs[:ip], virtualbox__intnet: nic
          else
            override.vm.network :private_network, :adapter => i, type: "dhcp", virtualbox__intnet: nic
          end
        end

        vb.customize ["modifyvm", :id,
          "--groups", "/Icinga Book/" + options[:domain],
          "--audio", "none",
          "--usb", "on",
          "--usbehci", "off",
        ].concat(vb_customize)
        vb.memory = options[:memory] 
      end
    end

  end
end
