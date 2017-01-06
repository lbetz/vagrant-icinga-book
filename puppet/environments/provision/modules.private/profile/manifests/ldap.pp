class profile::ldap::client {

  class { '::openldap::client':
    base        => 'dc=icinga-book,dc=local',
    uri         => ['ldap://gmw', ],
    tls_cacert  => '/etc/openldap/ssl/ca.pem',
    tls_reqcert => 'never',
  } ->
  file { '/etc/openldap/ssl':
    ensure => directory,
  }
  file { '/etc/openldap/ssl/ca.pem':
    ensure => file,
    source => 'puppet:///modules/profile/ca/ca.crt',
  }
}

class profile::ldap::server {

  File {
    owner => 'ldap',
    group => 'ldap',
  }

  class { '::openldap::server':
    ssl_cert => '/etc/openldap/ssl/slapd.pem',
    ssl_key  => '/etc/openldap/ssl/slapd.key',
  } ->

  file { '/etc/openldap/ssl/slapd.key':
    ensure => file,
    source => 'puppet:///modules/profile/private_keys/gmw.icinga-book.local.key',
    mode   => '0600',
  } ->
  file { '/etc/openldap/ssl/slapd.pem':
    ensure => file,
    source => 'puppet:///modules/profile/certs/gmw.icinga-book.local.crt',
  }

  openldap::server::schema { 'cosine':
    ensure => present,
  } ->
  openldap::server::schema { 'inetorgperson':
    ensure => present,
  } ->
  openldap::server::schema { 'nis':
    ensure => present,
  }

  openldap::server::database { 'dc=icinga-book,dc=local':
    rootdn => 'cn=admin,dc=icinga-book,dc=local',
    rootpw => 'secret',
  }

  #  openldap::server::access {
  #  'to attrs=userPassword,shadowLastChange by group="cn=LDAP Read Write,ou=groups,dc=icinga-book,dc=local" on dc=icinga-book,dc=local':
  #    access => 'write';
  #      'to attrs=userPassword,shadowLastChange by group="cn=LDAP Read Only,ou=groups,dc=icinga-book,dc=local" on dc=icinga-book,dc=local':
  #    access => 'read';
  #  'to attrs=userPassword,shadowLastChange by anonymous on dc=icinga-book,dc=local':
  #    access => 'auth';
  #  'to attrs=userPassword,shadowLastChange by self on dc=icinga-book,dc=local':
  #    access => 'write';
  #  'to attrs=userPassword,shadowLastChange by * on dc=icinga-book,dc=local':
  #    access => 'none';
  #}
  #openldap::server::access {
  #  'to attrs=cn,dc,gecos,gidNumber,homeDirectory,loginShell,member,memberUid,objectClass,ou,sn,uid,uidNumber,uniqueMember,entry by group="cn=LDAP Read Write,ou=groups,dc=icinga-book,dc=local" on dc=icinga-book,dc=local':
  #    access => 'write';
  #  'to attrs=cn,dc,gecos,gidNumber,homeDirectory,loginShell,member,memberUid,objectClass,ou,sn,uid,uidNumber,uniqueMember,entry by users on dc=icinga-book,dc=local':
  #    access => 'read';
  #  'to attrs=cn,dc,gecos,gidNumber,homeDirectory,loginShell,member,memberUid,objectClass,ou,sn,uid,uidNumber,uniqueMember,entry by anonymous on dc=icinga-book,dc=local':
  #    access => 'auth';
  #  'to attrs=cn,dc,gecos,gidNumber,homeDirectory,loginShell,member,memberUid,objectClass,ou,sn,uid,uidNumber,uniqueMember,entry by * on dc=icinga-book,dc=local':
  #    access => 'none';
  #}
  #openldap::server::access {
  #  'to * by group="cn=LDAP Read Write,ou=groups,dc=icinga-book,dc=local" on dc=icinga-book,dc=local':
  #    access => 'write';
  #  'to * by group="cn=LDAP Read Only,ou=groups,dc=icinga-book,dc=local" on dc=icinga-book,dc=local':
  #    access => 'read';
  #  'to * by * on dc=icinga-book,dc=local':
  #    access => 'none';
  #}
}
