class role::mailrelay {
  include profile::base
  include profile::icinga2::agent
  include profile::ldap::client
  include profile::postfix::mailrelay
}
