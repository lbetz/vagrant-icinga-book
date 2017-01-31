class role::puppet::master {
  include ::profile::base
  include ::profile::puppet::master
  include ::profile::puppet::puppetdb
}
