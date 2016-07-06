case $operatingsystem {
  'windows': {
    Package { provider => chocolatey, }
  }
}

node "draco" {
  include profile::base
  include profile::icinga2::agent
  include profile::router
  include dnsmasq
}

node "antlia" {
  include role::webserver
}

node "aquarius" {
  include role::appserver
}

node "fornax" {
  include role::monitorserver
}

node "sculptor" {
  include profile::base
  include profile::icinga2::slave
}

node "gmw" {
  include role::groupware
}

node "kmw" {
  include role::mailrelay
}

node "andromeda" {
  include profile::icinga2::agent
}

node default {
  include profile::base
  include profile::icinga2::agent
}
