class role::mailrelay {
  include profile::base
  include profile::puppet::agent
  include profile::ldap::client
  include profile::postfix::mailrelay
}
