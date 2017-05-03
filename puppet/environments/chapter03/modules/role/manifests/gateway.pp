class role::gateway {
  include ::profile::base
  include ::profile::security
  include ::profile::router
  include ::dnsmasq
}
