class role::webserver {
  include ::profile::base
  include ::profile::puppet::agent
  include ::profile::apache::www
  include ::profile::apache::online
  include ::profile::apache::cash
}
