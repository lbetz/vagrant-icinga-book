class postfix::install {

  package { 'postfix':
    ensure => installed,
  }

}
