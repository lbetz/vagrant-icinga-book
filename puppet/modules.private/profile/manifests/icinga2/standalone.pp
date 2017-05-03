class profile::icinga2::standalone {
  class { '::icinga2':
    features => [ 'checker', 'mainlog', 'notification', 'command', 'statusdata' ],
  }

  include ::profile::icinga2::plugins::monitoring
  include ::profile::icinga2::classicui
}
