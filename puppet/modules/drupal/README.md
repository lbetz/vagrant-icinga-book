Introduction
============

This is a module that allows you to manage many aspects of a multisite Drupal installation.

Features:

* Facts exposing core Drupal statistics
* Manages Drupal site variables
* Manages Drupal modules in all states. (absent, present/installed, disabled, uninstalled)
* Manages Drupal installation
    * Includes Drush for administration tasks
    * Multiple installation types:
        * Install from repositories
        * Install bundled tarball
        * Download directly from `d.o`
* Manages Drupal subsites (including `default`)
    * Includes vhost and database management if you're lazy
    * Configures `settings.php` for each subsite
        * Allows significant customization, with sane defaults
    * Installs site database with Drush

Limitations
============

This is still in early development. Pull requests are welcome!

It is recommended that the user manage the Apache (or other webserver) vhosts and
the Drupal database, but if requested, this module can manage simple setups.

If database management is enabled, the module will create a database and a
database user for each site. **If you attempt to reuse either for multiple sites
you will get duplicate resource definitions and Puppet will squeal**. If you wish
to reuse users or databases, manage them on your own.

Variables, sites, and themes are managed with namespaced titles, like many programming
languages. The name of the site should be separated from the name of the item being
managed with the double colon scope operator. Example: `'mysite.example.com::clean_url'`.

This is currently only tested with CentOS using system packages, and with MySQL
and SQLite. More testing and implementation is forthcoming.


Usage
============


### Managing the core Drupal installation on your node:

#### Classify and accept all defaults

    include drupal

#### Classify with a custom configuration

    class { 'drupal':
      installtype    => 'remote',
      database       => 'drupaldb',
      dbuser         => 'mydrupaluser',
      dbdriver       => 'pgsql',
    }

Available options for the `drupal` class. Note that each has a default, defined in `params.pp`.

    class drupal (
      $admin_password = randstr(),
      $database       = $drupal::params::database,
      $dbuser         = $drupal::params::dbuser,
      $dbpassword     = $drupal::params::dbpassword,
      $dbhost         = $drupal::params::dbhost,
      $dbport         = $drupal::params::dbport,
      $dbdriver       = $drupal::params::dbdriver,
      $dbprefix       = $drupal::params::dbprefix,
      $installtype    = $drupal::params::installtype,
      $update         = $drupal::params::update,
      $docroot        = $drupal::params::docroot,
      $writeaccess    = $drupal::params::writeaccess,
      $packagename    = $drupal::params::packagename,
      $drupalversion  = $drupal::params::drupalversion,
      $drushversion   = $drupal::params::drushversion,
      $managedatabase = $drupal::params::managedatabase,
      $managevhost    = $drupal::params::managevhost,
    )

Many configuration options are simply passed directly to `drupal::site`, which is used
to create and manage the `default` site.

### Managing subsites within your Drupal installation:

    drupal::site { 'funky.monkey.com':
      ensure         => present,
      database       => 'funky',
      dbuser         => 'funky',
      dbdriver       => 'pgsql',
      managedatabase => true,
      managevhost    => true,
    }

More usage can be discovered by reading the source of `manifests/init.pp` and
`manifests/site.pp`. I will add more PuppetDoc as I have time and development stabilizes.

#### Managing variables and modules

This allows you to manage the variables, modules, and themes for each site by namepacing
the title. Just like in most programming languages, the scope separator is the double colon.

For example:

    drupal_variable { 'mysite.example.com::clean_url':
      ensure => 'present',
      value  => '0',
    }

    drupal_module { 'mysite.example.com::trigger':
      ensure => present,
    }

    drupal_module { 'mysite.example.com::comment':
      ensure => absent,
    }

You can manage the default site variables by leaving the scope blank:

    drupal_variable { 'clean_url':
      ensure => 'present',
      value  => '0',
    }

    drupal_module { 'trigger':
      ensure => present,
    }

    drupal_module { 'comment':
      ensure => absent,
    }

or by specifying it explicitly:

    drupal_variable { 'default::clean_url':
      ensure => 'present',
      value  => '0',
    }

    drupal_module { 'default::trigger':
      ensure => present,
    }

    drupal_module { 'default::comment':
      ensure => absent,
    }

Contact
=======

* Author: Ben Ford
* Email: ben.ford@puppetlabs.com
* Twitter: @binford2k
* IRC (Freenode): binford2k


Special Thanks
=======

* Chris Bloom bloomcb@gmail.com: The man who knows no limits and provided some of the initial impetus
    for this project and someone to bounce ideas off.

License
=======

Copyright (c) 2013 Puppet Labs, info@puppetlabs.com

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
