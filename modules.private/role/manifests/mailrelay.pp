class role::mailrelay {
  include profile::base
  include profile::ldap::client
  include profile::postfix::mailrelay
}
