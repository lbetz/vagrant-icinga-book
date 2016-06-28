class role::appserver {
  include profile::base
  include profile::icinga2::agent
  include profile::tomcat
  include profile::postgres
}
