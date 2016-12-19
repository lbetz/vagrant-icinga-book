class repos::puppetlabs {

   File {
      owner => root,
      group => root,
      mode  => '0644',
   }

   case $::osfamily {

      'debian': {
         include apt

         apt::key { 'puppetlabs':
            key         => '4BD6EC30',
            key_source  => 'http://apt.puppetlabs.com/pubkey.gpg',
         }

         apt::source { 'puppetlabs':
            ensure      => present,
            comment     => 'Offical puppet repository',
            location    => 'http://apt.puppetlabs.com',
            release     => $::lsbdistcodename,
            repos       => 'main dependencies',
            include_src => false,
            pin         => '-10',
         }
      } # Debian

      'redhat': {
         yumrepo { 'puppetlabs-products':
            descr => "Puppet Labs Products El  ${::operatingsystemmajrelease} - \$basearch",
            baseurl => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/products/\$basearch",
            failovermethod => 'priority',
            enabled => '1',
            gpgcheck => '1',
            gpgkey => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
         }

         yumrepo { 'puppetlabs-deps':
            descr => "Puppet Labs Dependencies El ${::operatingsystemmajrelease} - \$basearch",
            baseurl => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/dependencies/\$basearch",
            failovermethod => 'priority',
            enabled => '1',
            gpgcheck => '1',
            gpgkey => 'http://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs',
         }
      } # RedHat

      default: {
         fail("Your operatingsystem ${::operatingsystem} is not supported.")
      }

   } # case

}
