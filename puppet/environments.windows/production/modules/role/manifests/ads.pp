class role::ads {
  include ::profile::base
  include ::profile::nscp
  include ::profile::icinga2::agent
  include ::profile::ads
}
