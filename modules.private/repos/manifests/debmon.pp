class repos::debmon(
   $ensure = present,
   $repos  = 'main'
) {

   # Validate parameter
   validate_re($ensure, '^(present|absent)$',
      "${ensure} is not supported for ensure. Allowed values are 'present' and 'absent'.")

   case $::osfamily {

      'debian': {
         include apt

         file { '/etc/apt/apt.conf.d/99recommends':
            ensure  => file,
            content => 'APT::Install-Recommends "false";',
         } ->

         apt::source { 'debmon':
            ensure      => $ensure,
            location    => 'http://debmon.org/debmon',
            release     => "debmon-$::lsbdistcodename",
            repos       => $repos,
            key         => '29D662D2',
            key_source  => 'http://debmon.org/debmon/repo.key',
            include_src => false,
         }
      } # Debian

      default: {
         fail("Your operatingsystem ${::operatingsystem} is not supported.")
      }
   }

}
