class role::groupware {
  include ::profile::base
  include ::profile::ldap::client
  include ::profile::ldap::server
  include ::profile::postfix::groupware
  include ::profile::icinga2::agent
}
