class profile::icinga2(
  $confd     = false,
) {

  Class['profile::icinga2::plugins::monitoring']
    -> Package['icinga2']
    -> Class['icinga2']


  include profile::repo::icinga
  include profile::icinga2::plugins::monitoring

  package { 'icinga2':
    ensure => installed,
  }

  class { '::icinga2':
    manage_package => false,
    constants      => lookup('profile::icinga2::constants', Hash, 'deep', {}),
    confd          => $confd,
  }

  if !is_bool($conf) {
    file { $confd:
      ensure  => directory,
      owner   => 'icinga',
      group   => 'icinga',
      mode    => '0750',
      source  => '/etc/icinga2/conf.d',
      recurse => true,
      tag     => 'icinga2::config::file',
    }
  }

  if $::osfamily != 'windows' {
    Package['icinga2'] -> User['icinga'] ~> Class['icinga2']

    user { 'icinga':
      ensure  => present,
      groups  => [ 'nagios' ],
    }

    ssh_authorized_key { 'icinga@fornax':
      ensure  => present,
      key     => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCp6KmsaI43afIYVMqNiujdMww9ZaVNwH0vpMZUw6W8ichvR533jyLbg25E15oXS0fAyQ3t+4B5QxuUPCZodJHUf3ZCnKL1hzZzboQt9XrCuiQC+8xo97sYP1iD+bhWbsZVMeJQXXZH1S/B5j6t/k5WBs7QTLNG4foXZYPwKdd8aar/0H7y6/ASJ0unVcvUgbP/75/CoW+8DQuUQU6zFFFakUWsW2YVxfpHHMGDVnkTr4OIocZxSOQ7g6csVSHHgivUCt1aAPQmVj9FnL9b4o9e1pTVUCi6uJqzTRXlFG8OLXSjhDoHNfNd7UCoKefcdWUzGd1tRCtbbvzMGcH0JzaMw7VF/Xx8E6KBo9c///LxuJjMHZSLe4P881LbY/gXhB3iwLAMapESSpbRZ3QRrRK1deAdZaKRuEJym7boIpAMsrsyuQ0Ky3TuBAVR7/RNAQiCGlcVbiQlZCKGfDqg9guuafOTcyPP2VclSnsoIdK2tlp6EaMu9nYmlHFdeaix0KLezAKRyEJUHZ1hz/f0G2n/iSUxLeGk4ToG9FIPSKhOCA+0GYnTOvVEmSUUpjTi387G5xjBdKhOTG5w+KL81/HEgX2i7eyGsY0ZBxEPKBTFzwu0HUz+nzetB8n8AXmvAw4Kju5o6gGaNcCgtnqWTIcmuRyfKXoR1qKoyFzrFkl2Xw==',
      type    => 'ssh-rsa',
      user    => 'icinga',
    }
  }
}
