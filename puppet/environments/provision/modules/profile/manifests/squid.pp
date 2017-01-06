class profile::squid::extern {
  class { '::squid3':
    acl                 => [
      'icinga src 172.16.2.11/32',
      'icinga-book.net src 172.16.2.0/24',
    ],
    http_access         => [
      'allow icinga-book.net',
      'allow manager icinga',
    ],
    template            => 'short',
    use_deprecated_opts => false,
  }
}

class profile::squid::intern {
  class { '::squid3':
    acl                 => [
      'icinga src 172.16.1.11/32',
      'icinga-book.local src 172.16.1.0/24',
    ],
    http_access         => [
      'allow icinga-book.local',
      'allow manager icinga',
    ],
    config_array        => [
      'cache_peer 172.16.2.14 parent 3128 0',
    ],
    template            => 'short',
    use_deprecated_opts => false,
  }
}
