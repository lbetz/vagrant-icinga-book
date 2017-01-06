class role::webserver {
  include ::profile::base
  include ::profile::apache::www
  include ::profile::apache::online
  include ::profile::apache::cash
  include ::profile::icinga2::agent
}
