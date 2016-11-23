case $operatingsystem {
  'windows': {
    Package { provider => chocolatey, }
  }
}

node "draco" {
  include role::gateway
}

node "antlia" {
  include role::webserver
}

node "aquarius" {
  include role::appserver
}

node "fornax" {
  include role::monitor::master
}

node "sculptor" {
  include role::monitor::satellite
}

node "gmw" {
  include role::groupware
}

node "kmw" {
  include role::mailrelay
}

node "andromeda" {
  include role::ads
}

node "carina" {
  include role::puppetmaster
}

node "sagittarius" {
  include role::proxy::extern
}

node "sextans" {
  include role::proxy::intern
}

node default {
  include profile::base
}
