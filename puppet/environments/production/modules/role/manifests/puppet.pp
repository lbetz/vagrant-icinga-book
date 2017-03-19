class role::puppet::master {
  include ::profile::base
  include ::profile::puppet::server::master
  include ::profile::icinga2::agent
}
