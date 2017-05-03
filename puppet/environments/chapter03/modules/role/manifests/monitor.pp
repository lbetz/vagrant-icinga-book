class role::monitor::server {
  include ::profile::base
  include ::profile::security
  include ::profile::icinga2::standalone
  include ::profile::icinga2::classicui
}
