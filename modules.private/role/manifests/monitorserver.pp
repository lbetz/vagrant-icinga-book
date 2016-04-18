class role::monitorserver {
  include profile::base
  include profile::icinga2::master
}
