class profile::apache::icinga {
  class { ::apache:
    purge_configs => false
  }

  include ::apache::mod::status
  include ::apache::mod::php
}

class profile::apache::www {
  include ::apache
  include ::apache::mod::status

  include ::profile::repo::epel

  package { 'php-pgsql':
    ensure => installed,
    before => Class[Apache],
  }

  apache::vhost { 'www.icinga-book.net':
    port               => '80',
    docroot            => '/var/www/html',
    directories        => [
      { path           => '/var/www/html',
        options        => [ 'MultiViews', 'FollowSymLinks' ],
        allow_override => 'All',
      },
    ],
  }

  class { '::drupal':
    database   => 'drupal',
    dbhost     => 'aquarius',
    dbuser     => 'drupal',
    dbpassword => 'drupal',
    dbdriver   => 'pgsql',
  }

  file { '/var/www/html/.htaccess':
    ensure  => file,
    mode    => '0644',
    content => "AddLanguage en .en\nAddLanguage de .de\nLanguagePriority en de\nForceLanguagePriority Prefer\n",
  }

  file { '/var/www/html/index.html.en':
    ensure  => file,
    mode    => '0644',
    content => "
<html>
<body>
Icinga Book
<table width=100% height=100%>
  <td align=center>
    <img src='./icinga-book.jpg'>
  </td>
</body>
</html>",
  }

  file { '/var/www/html/index.html.de':
    ensure  => file,
    mode    => '0644',
    content => "
<html>
<body>
Icinga Buch
<table width=100% height=100%>
  <td align=center>
    <img src='./icinga-book.jpg'>
  </td>
</body>
</html>",
  }

  file { '/var/www/html/icinga-book.jpg':
    ensure => file,
    source => 'puppet:///modules/profile/apache/icinga-book.jpg',
  }
}

class profile::apache::online {
  include ::apache
  include ::apache::mod::status

  file { '/etc/ssl/online.icinga-book.net.key':
    ensure => file,
    mode => '0600',
    source => 'puppet:///modules/profile/ssl/private_keys/online.icinga-book.net.key',
    notify => Class['::apache'],
  }

  file { '/etc/ssl/online.icinga-book.net.crt':
    ensure => file,
    mode => '0644',
    source => 'puppet:///modules/profile/ssl/certs/online.icinga-book.net.crt',
    notify => Class['::apache'],
  }

  apache::vhost { 'online.icinga-book.net':
    port     => '443',
    docroot  => '/var/www/online',
    ssl      => true,
    ssl_cert => '/etc/ssl/online.icinga-book.net.crt',
    ssl_key  => '/etc/ssl/online.icinga-book.net.key',
  }

  file { '/var/www/online/index.html':
    ensure  => file,
    mode    => '0644',
    content => "total amount: 44.95 $\n",
  }
}

class profile::apache::cash {
  include ::apache
  include ::apache::mod::status

  file { '/etc/ssl/cash.icinga-book.net.key':
    ensure => file,
    mode => '0600',
    source => 'puppet:///modules/profile/ssl/private_keys/cash.icinga-book.net.key',
    notify => Class['::apache'],
  }

  file { '/etc/ssl/cash.icinga-book.net.crt':
    ensure => file,
    mode => '0644',
    source => 'puppet:///modules/profile/ssl/certs/cash.icinga-book.net.crt',
    notify => Class['::apache'],
  }

  apache::vhost { 'cash.icinga-book.net':
    port     => '443',
    docroot  => '/var/www/cash',
    ssl      => true,
    ssl_cert => '/etc/ssl/cash.icinga-book.net.crt',
    ssl_key  => '/etc/ssl/cash.icinga-book.net.key',
  }
}
