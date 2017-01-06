require 'pathname'
require 'uri'

Puppet::Type.newtype(:drupal_theme) do
  desc "Manages a Drupal theme"

  def self.title_patterns
    [
      [ /^([\.|\w]+)::(\w+)$/, [ [ :site, lambda {|x| x} ], [ :name, lambda {|x| x} ] ] ],
      [ /^(\w+)$/, [ [ :name, lambda {|x| x} ] ] ]
    ]
  end

  ensurable do
    desc "The state the module should be in."
    defaultvalues

    newvalue(:enabled) do
      provider.create
    end

    newvalue(:disabled) do
      provider.destroy
    end
  end

  newparam(:site, :namevar => true) do
    desc "Site name. Can be set by using a title in the format 'site::module'"
    newvalues /^[\.|\w]+$/
    defaultto 'default'
  end

  newparam(:name, :namevar => true) do
    desc "Name of the theme. Can be set by using a title in the format 'site::module'"
    newvalues /^[\.|\w]+(::\w+)?$/
  end

  newproperty(:label) do
    desc 'Human readable name of the theme'
  end

  newproperty(:package) do
    desc 'Package the theme belongs to'
    newvalues /^\S+$/
  end

  newproperty(:version) do
    desc "The the version of the theme"
  end

end
