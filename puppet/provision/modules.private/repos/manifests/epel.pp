class repos::epel {

   case $::osfamily {

      'redhat': {

         yumrepo { 'epel':
            descr => "Extra Packages for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
            mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-${::operatingsystemmajrelease}&arch=\$basearch",
            failovermethod => 'priority',
            enabled => '1',
            gpgcheck => '1',
            gpgkey => "http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-${::operatingsystemmajrelease}",
         }

      } # RedHat

      default: {
         fail("Your operatingsystem ${::operatingsystem} is not supported.")
      }

   } # case

}
