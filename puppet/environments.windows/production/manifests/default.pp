case $operatingsystem {
  'windows': {
    Package { provider => chocolatey, }
  }
}

node "andromeda" {
  include ::role::ads
}

node default {
  include ::profile::base
}
