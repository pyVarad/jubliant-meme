class cabriolet::commonrhel {
  class { "cabriolet::commonrhel::dependencies": } ->
  class { "cabriolet::commonrhel::yumRepo": }
}

class cabriolet::commonrhel::dependencies {
  $deb_pkg = [
              "coreutils",
              "curl",
              "git",
              "htop",
              "ntp",
              "tzdata",
              ]

  firewall { '100 Allow http and https access':
    dport   => [80, 443],
    proto  => tcp,
    action => accept,
  }
}

class cabriolet::commonrhel::yumRepo {
  $packages = [
      "openssl-devel",
      "python-pip",
      "python-devel",
      "libffi-devel"
  ]

  file {'GPGKEY':
    ensure  => 'present',
    source  => 'puppet:///modules/cabriolet/epel/RPM-GPG-KEY-EPEL-6',
    path    => '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
  }

  yumrepo { 'epelRelease':
    ensure         => 'present',
    descr          => 'Extra Packages for Enterprise Linux 6 - $basearch',
    enabled        => '1',
    failovermethod => 'priority',
    gpgcheck       => '1',
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6',
    mirrorlist     => 'https://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch',
  }

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
