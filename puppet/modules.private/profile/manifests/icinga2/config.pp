class profile::icinga2::config(
  $confd = false,
) {

  if $confd {
    $target = '/etc/icinga2/conf.d'
  } else {
    $target = '/etc/icinga2/zones.d'
  }

  file { $target:
    ensure             => directory,
    owner              => 'icinga',
    group              => 'icinga',
    mode               => '0750',
    recurse            => true,
    force              => true,
    purge              => true,
    source             => "puppet:///modules/profile/icinga2/${::chapter}/",
    source_permissions => 'ignore',
    tag                => 'icinga2::config::file',
    notify             => Class['::icinga2::service'],
  }

}
