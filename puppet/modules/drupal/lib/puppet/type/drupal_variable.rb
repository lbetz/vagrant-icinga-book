require 'pathname'
require 'uri'

Puppet::Type.newtype(:drupal_variable) do
  desc "Manages a Drupal variable"
  ensurable

  def self.title_patterns
    [
      [ /^([\.|\w]+)::(\w+)$/, [ [ :site, lambda {|x| x} ], [ :name, lambda {|x| x} ] ] ],
      [ /^(\w+)$/, [ [ :name, lambda {|x| x} ] ] ]
    ]
  end

  newparam(:site, :namevar => true) do
    desc "Site name. Can be set by using a title in the format 'site::variable'"
    newvalues /^[\.|\w]+$/
    defaultto 'default'
  end

  newparam(:name, :namevar => true) do
    desc "Variable name. Can be set by using a title in the format 'site::variable'"
    newvalues /^[\.|\w]+(::\w+)?$/
  end

  newproperty(:value) do
    desc "The value this variable should be set to"
  end

end
