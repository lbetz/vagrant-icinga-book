class role::icinga2::master {
  include profile::icinga2::master
  include profile::icinga2::classicui
  include profile::icinga2::icingaweb2
}

class role::icinga2::slave {
  include profile::icinga2::slave
}

class role::icinga2::agent {
  include profile::icinga2::agent
}

class role::icinga2::ssh {
  include profile::icinga2::base
}
