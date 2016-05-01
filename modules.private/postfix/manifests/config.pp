class postfix::config {

  $master_cf_source = $::postfix::master_cf_source
  $main_cf_source = $::postfix::main_cf_source

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  file { '/etc/postfix/master.cf':
    ensure => file,
    source => $master_cf_source,
  }

  file { '/etc/postfix/main.cf':
    ensure => file,
    source => $main_cf_source,
  }

}
