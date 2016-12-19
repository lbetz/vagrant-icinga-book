class nscp::config inherits nscp::params {

  file { $config:
    ensure             => file,
    source_permissions => 'ignore',
    content            => regsubst(template("nscp/nsclient.ini.erb"), '\n', "\r\n", 'EMG'),
  }

}
