class profile::tomcat {

  package { 'tomcat':
    ensure => installed,
  } ->

  file { '/var/lib/tomcat/webapps/jolokia.war':
    ensure => file,
    source => 'puppet:///modules/profile/jolokia-war-1.3.3.war',
  } ~>

  service { 'tomcat':
    ensure => running,
    enable => true,
  }

}
