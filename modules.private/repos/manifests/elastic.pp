class repos::elastic {

   case $::osfamily {

      'redhat': {

         yumrepo { 'elastic-5.x':
            descr => 'Elastic repository for 5.x packages',
            baseurl => 'https://artifacts.elastic.co/packages/5.x/yum',
            enabled => '1',
            gpgcheck => '1',
            gpgkey => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch',
         }

      } # RedHat

      default: {
         fail("Your operatingsystem ${::operatingsystem} is not supported.")
      }

   } # case

}

