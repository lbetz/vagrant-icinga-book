class repos::plugins {

   case $::osfamily {

      'redhat': {

         yumrepo { 'icinga-book':
            descr => "Extra Packages for Icinga Book Project ${::lsbmajdistrelease} - \$basearch",
            baseurl => "http://download.icinga-book.net/epel/7",
            failovermethod => 'priority',
            enabled => '1',
            gpgcheck => '0',
         }

      } # RedHat

      default: {
         fail("Your operatingsystem ${::operatingsystem} is not supported.")
      }

   } # case

}
