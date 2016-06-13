class role::monitorserver {
  include profile::base
  include profile::apache
  include profile::icinga2::master
  include profile::icinga2::classicui
  include profile::ldap::client
}
