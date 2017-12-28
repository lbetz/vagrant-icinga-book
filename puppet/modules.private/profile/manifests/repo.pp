class profile::repo::epel {
  class { '::repos::epel':
    stage => 'repos',
  }
}

class profile::repo::icinga {
  class { '::repos::icinga':
    stage => 'repos',
  }
}

class profile::repo::plugins {
  class { '::repos::plugins':
    stage => 'repos',
  }
}
