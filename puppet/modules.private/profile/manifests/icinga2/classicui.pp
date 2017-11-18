class profile::icinga2::classicui {
  include ::profile::apache::icinga

  package { 'icinga2-classicui-config':
    ensure => installed,
  } ->
  package { 'icinga-gui':
    ensure => installed,
    notify => Class['apache'],
  }

  include ::icinga2::feature::command
  include ::icinga2::feature::compatlog
  include ::icinga2::feature::statusdata
}
