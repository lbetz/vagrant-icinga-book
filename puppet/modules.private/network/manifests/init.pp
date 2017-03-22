class network($dns = 'yes') {

  case $::osfamily {
    'redhat': {
      service { 'firewalld':
        ensure => 'stopped',
        enable => false,
      }

      exec { 'selinux-disable':
        path    => '/usr/sbin:/usr/bin',
        command => 'setenforce 0',
        unless  => 'getenforce |/bin/grep -n Permissive 2>&1>/dev/null',
      }
      file_line { 'selinux-disable':
        path   => '/etc/sysconfig/selinux',
        line  => 'SELINUX=permissive',
        match => '^SELINUX=',
      }

      file_line { 'peerdns':
        path   => '/etc/sysconfig/network-scripts/ifcfg-eth0',
        line  => "PEERDNS=${dns}",
        match => '^PEERDNS=',
      } ~>
      service { 'network':
        ensure => running,
        enable => true,
      }
    }
    'windows': {
      exec {"Disable-Firewall-Profile-private":
        command  => 'Set-NetFirewallProfile -Profile private -Enabled False',
        onlyif   => 'if (!(Get-NetFirewallProfile -Profile private).Enabled) { exit 1 }',
        provider => powershell,
      }
      exec {"Disable-Firewall-Profile-public":
        command  => 'Set-NetFirewallProfile -Profile public -Enabled False',
        onlyif   => 'if (!(Get-NetFirewallProfile -Profile public).Enabled) { exit 1 }',
        provider => powershell,
      }
    }
  }

}
