class role::appserver {
  include ::profile::base
  include ::profile::tomcat
  include ::profile::postgres::drupal
  include ::profile::icinga2::agent
}
