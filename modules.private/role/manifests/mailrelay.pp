class role::mailrelay {
  include profile::base
  include profile::ldap::client
  include profile::postfix::mailrelay
  include profile::icinga2::agent
}
