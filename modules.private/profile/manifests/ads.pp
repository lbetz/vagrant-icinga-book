class profile::ads {
  include profile::base

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

  class { 'windows_ad':
    install                => present,
    installmanagementtools => true,
    restart                => true,
    installflag            => true,
    configure              => present,
    configureflag          => true,
    domain                 => 'forest',
    domainname             => 'icinga-book.ads',
    netbiosdomainname      => 'ADS',
    domainlevel            => '6',
    forestlevel            => '6',
    databasepath           => 'c:\\windows\\ntds',
    logpath                => 'c:\\windows\\ntds',
    sysvolpath             => 'c:\\windows\\sysvol',
    installtype            => 'domain',
    dsrmpassword           => 'Bia3cho0',
    installdns             => 'yes',
    localadminpassword     => 'vagrant',
  }
}
