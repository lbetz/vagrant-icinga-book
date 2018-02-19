class repos::plugins {

   case $::osfamily {

      'redhat': {

         yumrepo { 'icinga-book':
            descr          => "Extra Packages for Icinga Book Project ${::operatingsystemmajrelease} - \$basearch",
            baseurl        => 'https://packages.prefork.de/pub/epel/$releasever',
            failovermethod => 'priority',
            enabled        => '1',
            gpgcheck       => '0',
         }

      } # RedHat

      default: {
         fail("Your operatingsystem ${::operatingsystem} is not supported.")
      }

   } # case

}
