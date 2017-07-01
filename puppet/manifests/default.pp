case $operatingsystem {
  'windows': {
    Package { provider => chocolatey, }
  }
}

lookup('classes', {merge => unique}).include
notify { $::chapter: }
