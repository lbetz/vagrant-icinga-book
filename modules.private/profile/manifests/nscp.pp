class profile::nscp {

  class { 'nscp':
    ensure => running,
    enable => true,
  }

  file { 'C:/Program Files/NSClient++/scripts/custom/check_time.vbs':
    ensure             => file,
    source_permissions => ignore,
    source             => 'puppet:///modules/profile/icinga2/scripts/check_time.vbs',
    require            => Class['nscp'],
  }
  file { 'C:/Program Files/NSClient++/scripts/custom/check_ad.vbs':
    ensure             => file,
    source_permissions => ignore,
    source             => 'puppet:///modules/profile/icinga2/scripts/check_ad.vbs',
    require            => Class['nscp'],
  }
  file { 'C:/Program Files/NSClient++/scripts/custom/check_windows_updates.ps1':
    ensure             => file,
    source_permissions => ignore,
    source             => 'puppet:///modules/profile/icinga2/scripts/check_windows_updates.ps1',
    require            => Class['nscp'],
  }
}
