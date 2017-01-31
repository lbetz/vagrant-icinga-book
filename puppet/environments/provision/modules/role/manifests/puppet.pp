class role::puppet::master {
  include ::profile::base
  include ::profile::puppet::server::master
}
