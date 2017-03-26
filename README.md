# Introduction

This is the setup described and used in the [Icinga 2 book](http://amzn.to/2eOU1ey).

The original project for these files is the version of [lbetz](https://github.com/lbetz/vagrant-icinga-book). All others are forks and might be used to create pull requests and patches.

# Requirements

* Vagrant, recommended version >1.8
* Vagrant plugin vbguest
* Virtualbox
* r10k

**By now, the Windows boxes are not publicly available due to copyright restrictions. We try to work around this.**

Example for OSX:

    $ vagrant plugin install-vbguest
    $ sudo gem install r10k

# Setup

    $ cd puppet
    $ r10k puppetfile install

# Run

    $ vagrant up --provider virtualbox

## Run a minimal setup

Since these boxes were created to simulate an entire network, at least the gateway node `draco` is needed to run other boxes.

The node `fornax` is the Icinga 2 master - you will want to start experimenting with this node but you should start it as the last of the setup. As default the monitoring configuration is deployed so that all machines are monitored.

## Disable monitoring configuration

The configuration files contain all monitoring objects i.e. hosts, services etc. are stored in modules.private/profile/files/icinga2/zones.d/ and will be deployed to /etc/icinga2/zones.d on `fornax` automatically during the provision process. To disable this behavoir edit the following file before provisioning the VM `fornax`:

    $ cd vagrant-icinga-book
    $ vi hieradata/fornax.yaml
      profile::icinga2::master::manage_config: false

# Description of virtual machines

All machines are located to one of two networks. The internal network `icinga-book.local` (172.16.1.0/24) is connected to the dmz `icinga-book.net` (172.16.2.0/24) via the default gateway `draco`.

All machines are CenOS 7 if nothing different is descripted.

## draco

Default gateway to the internat with DHCP, DNS for both zones. Host with two local interfaces for both network zones and a NAT interface as gateway to the internet.

## aquarius (internal net)

Contains a Postgresql DBMS with database `drupal` for the website `www.icinga-book.net/drupal` and a tomcat based application server.

## carina (internal net)
Puppet master with puppetdb.

## antlia (dmz)

Has an installed Apache webserver with three virtual hosts. An internet portal `www.icinga-book.net` in english and german, `online.icinga-book.net` via HTTPS simulate an online shop and `cash.icinga-book.net` via HTTPS serves a receipt page. If you set a name solution for all three names to 127.0.0.1 i.e. in your hosts file you can access the HTTP pages via port 8080 and the HTTPS pages via 8443. Both ports are forwarded to the VM.

## gmw (internal net)

Installation of Postfix and Dovecot. The Postfix is listing on smtp and submission, the dovecot is configured for IMAPS.

## kmw (dmz)

Mail relay for `gmw` with postfix (SMTP) and clamav (unix socket).

## sextans (internal net)

A squid installation as webproxy on standard port 3128. The traffic is rerouted to the external squid on `sagittarius`.

## sagittarius (dmz)

The external webproxy for connections from the internal squid and all hosts in the dmz.

## sculptor (dmz)

The Icinga 2 Satellit for all checks to the dmz.

## fornax (internal net)

Icinga 2, Icinga Web 2, MySQL DBMS and databases for both (`icinga` and `icingaweb2`). The VM has an additional net interface with the ip 192.168.56.10 that is accessable from your local machine via 192.168.56.1.
