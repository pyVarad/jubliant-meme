class cabriolet::webapp {
  class { "cabriolet::webapp::nginxSetup": } ->
  class { "cabriolet::webapp::nginxConfigure": } ->
  class { "cabriolet::webapp::nginxSitesEnabled": } ->
  class { "cabriolet::commonrhel::webAppDependencies": }
}

#
# Declare contained classes
#

class cabriolet::webapp::nginxSetup {
  package {'apache':
    ensure => absent,
  }
  package {'nginx':
      ensure => installed,
      require => [Package['apache'], Yumrepo["epelRelease"]],
  }
}

class cabriolet::webapp::nginxConfigure {
  if $operatingsystem == 'CentOS'{
    file { "nginx.conf":
      path   => "/etc/nginx/nginx.conf",
      ensure => file,
      mode   => 0644,
      owner  => root,
      group  => root,
      source => "puppet:///modules/cabriolet/nginx/cabriolet-nginx-CentOS.conf",
      }
    } else {
      file { "nginx.conf":
        path   => "/etc/nginx/nginx.conf",
        ensure => file,
        mode   => 0644,
        owner  => root,
        group  => root,
        source => "puppet:///modules/cabriolet/nginx/cabriolet-nginx-debian.conf",
      }
    }
}

class cabriolet::webapp::nginxSitesEnabled {
  file {'create-sites-available-directory':
    ensure => directory,
    path => "/etc/nginx/sites-available",
  }

  service {'nginx':
      ensure => running,
      enable => true
  }

  file { "sites-available.conf":
    path   => "/etc/nginx/sites-available/sites-available.conf",
    ensure => file,
    mode   => 0644,
    owner  => root,
    group  => root,
    source => "puppet:///modules/cabriolet/nginx/nginx-sites-available.conf",
    require => File['create-sites-available-directory'],
  }

  file {'create-sites-enabled-directory':
    ensure => directory,
    path => "/etc/nginx/sites-enabled",
  }

  file { "sites-enabled.conf":
    path   => "/etc/nginx/sites-enabled/sites-enabled.conf",
    ensure => link,
    mode   => 0644,
    owner  => root,
    group  => root,
    target => "/etc/nginx/sites-available/sites-available.conf",
    require => File['sites-available.conf'],
    notify => Service['nginx']
  }

  exec { 'setBoolSELinux':
    command => 'sudo setsebool -P httpd_can_network_connect 1',
    path    => '/usr/bin/',
  }
}

class cabriolet::commonrhel::webAppDependencies {
  $packages = [
    "openssl-devel",
    "python2-pip",
    "python-devel",
    "libffi-devel"
  ]
  package { $packages:
    ensure => present,
    require => Yumrepo['epelRelease'],
  }

  exec { 'requirements':
    command => 'sudo pip install -r requirements.txt',
    cwd => '/webapp/FlaskApp/',
    path    => '/usr/bin/',
    require => Package[$packages]
  }
}
