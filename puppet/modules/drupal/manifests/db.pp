## This is not really the "Puppet Way" but most Drupal devs I asked
 # **really** wanted this. So against my better judgement, the site
 # type will instantiate a db for you if you ask it to.
 #
 # The major limitation is that you cannot use the same db or user
 # for multiple sites.
 ##
define drupal::db (
  $ensure   = present,
  $dbdriver,
  $user     = undef,
  $password = undef,
  $host     = 'localhost',
  $grant    = ['all'],
) {
  case $dbdriver {
    'mysql': {
      # just make sure these are installed
      include mysql::server
      include mysql::php

      mysql::db { $database:
        ensure   => $ensure,
        user     => $user,
        password => $password,
        host     => $host,
        grant    => $grant,
      }
    }
    'pgsql': {
      include postgresql::server
      if ! defined(Package['php-pgsql']) {
        package { 'php-pgsql':
          ensure   => present,
        }
      }

      if $ensure == absent {
        notify { 'The puppetlabs/postgresql module does not yet support removing a database': }
      }
      else {
        if is_array($grant) {
          $real_grant = $grant[0]
        }
        postgresql::db { $database:
#         ensure   => $ensure,
          user     => $user,
          password => $password,
          grant    => $real_grant,
        }
      }
    }
    'sqlite': {
      # sqlite is built in now, so I guess we've got nothing to do, eh.
    }
  }
}
