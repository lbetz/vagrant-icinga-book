class role::groupware {
  include profile::base
  include profile::ldap::server
  include profile::postfix::groupware
}
