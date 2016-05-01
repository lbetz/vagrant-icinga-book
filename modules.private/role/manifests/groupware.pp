class role::groupware {
  include profile::base
  include profile::icinga2::agent
  include profile::ldap::server
  include profile::postfix
}
