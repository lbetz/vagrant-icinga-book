class profile::ads {
  include profile::base

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
