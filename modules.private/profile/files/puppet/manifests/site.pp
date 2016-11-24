stage { 'first': } -> stage { 'repos': } -> Stage['main']

node "fornax.icinga-book.local" {
  include role::icinga2::master
}

node "sculptor.icinga-book.net" {
  include role::icinga2::slave
}

node "phoenix.icinga-book.local" {
  include role::icinga2::ssh
}

node "sextans.icinga-book.local" {
  include role::icinga2::ssh
}

node "sagittarius.icinga-book.net" {
  include role::icinga2::ssh
}

node /^andromeda/ {
}

node default {
  include role::icinga2::agent
}
