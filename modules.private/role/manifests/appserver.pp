class role::appserver {
  include profile::base
  include profile::puppet::agent
  include profile::tomcat
  include profile::postgres::drupal
}
