class nscp(
  $ensure = running,
  $enable = true,
) inherits nscp::params {

  validate_re($ensure, '^(running|stopped)', 'ensure must be running or stopped')
  validate_bool($enable)

  anchor { '::nscp::begin':
    notify => Class['nscp::service'],
  }
  -> class { '::nscp::install': }
  -> class { '::nscp::config': }
  ~> class { '::nscp::service': }
  -> anchor { '::nscp::end': }

}
