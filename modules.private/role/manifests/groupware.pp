class role::groupware {
  include profile::base
  include profile::puppet::agent
  include profile::ldap::server
  include profile::postfix::groupware
}
