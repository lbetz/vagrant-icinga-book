rpm --import https://getfedora.org/static/352C64E5.txt
rpm -q epel-release 1>/dev/null || rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
rpm -q puppetlabs-release 1>/dev/null || rpm -ivh https://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
rpm -q puppet 1>/dev/null || yum -y install puppet
