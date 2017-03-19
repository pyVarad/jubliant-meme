# Install common dependencies for the project here
class cabriolet::common {
  class { 'cabriolet::common::dependencies': }
}

# Sequentially arrange the dependencies here.
class cabriolet::common::dependencies {
  $deb_pkg = [
              'coreutils',
              'curl',
              'git',
              'htop',
              'ntp',
              'tzdata',
              ]

  firewall { '100 Allow http and https access':
    dport  => [80, 443],
    proto  => tcp,
    action => accept,
  }

  exec { 'requirements':
    command => 'sudo pip install -r requirements.txt',
    cwd     => '/webapp/FlaskApp/',
    path    => '/usr/bin/',
    require => [Exec['upgrade-python-pip']]
  }
}
