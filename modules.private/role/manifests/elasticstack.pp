class role::elasticstack {
  include 'profile::elasticsearch'
  include 'profile::logstash'
  include 'profile::kibana'
  include 'profile::base'
}
