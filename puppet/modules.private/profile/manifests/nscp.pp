class profile::nscp {

  class { '::nscp':
    ensure => stopped,
    enable => false,
  }

  -> file { 'C:/Program Files/NSClient++/scripts/custom/check_time.vbs':
    ensure             => file,
    source_permissions => ignore,
    source             => 'puppet:///modules/profile/icinga2/scripts/check_time.vbs',
  }
  -> file { 'C:/Program Files/NSClient++/scripts/custom/check_ad.vbs':
    ensure             => file,
    source_permissions => ignore,
    source             => 'puppet:///modules/profile/icinga2/scripts/check_ad.vbs',
  }
  -> file { 'C:/Program Files/NSClient++/scripts/custom/check_windows_updates.ps1':
    ensure             => file,
    source_permissions => ignore,
    source             => 'puppet:///modules/profile/icinga2/scripts/check_windows_updates.ps1',
  }
}
