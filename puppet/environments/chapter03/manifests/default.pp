node "draco.icinga-book.local" {
  include ::role::gateway
}

node "fornax.icinga-book.local" {
  include ::role::monitor::server
}
