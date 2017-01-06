class repos::icinga {

   case $::osfamily {

      'redhat': {

         yumrepo { 'ICINGA-release':
            descr => 'ICINGA (stable release for epel)',
            baseurl => 'http://packages.icinga.org/epel/$releasever/release/',
            failovermethod => 'priority',
            enabled => '1',
            gpgcheck => '1',
            gpgkey => 'http://packages.icinga.org/icinga.key',
         }

      } # RedHat

      default: {
         fail("Your operatingsystem ${::operatingsystem} is not supported.")
      }

   } # case

}
