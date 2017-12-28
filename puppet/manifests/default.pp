stage { 'first': } -> stage { 'repos': } -> Stage['main']

case $operatingsystem {
  'windows': {
    Package { provider => chocolatey, }
  }
}

lookup('classes', {merge => unique}).include
