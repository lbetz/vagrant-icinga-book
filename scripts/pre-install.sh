#rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppet
rpm -aq |grep puppetlabs-release 1>/dev/null || yum install -y https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm #https://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-12.noarch.rpm

rpm -q puppet-agent || yum install -y puppet-agent
