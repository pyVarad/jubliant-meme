## Common configuration for yum package managers.
class cabriolet::commonrhel {
  class { 'cabriolet::commonrhel::dependencies': } ->
  class { 'cabriolet::commonrhel::yumRepo': }
}

## Dependency setup here.
class cabriolet::commonrhel::dependencies {
  $deb_pkg = [
              'coreutils',
              'curl',
              'git',
              'htop',
              'ntp',
              'tzdata',
              ]

  package { 'iptables-services':
      ensure  => installed,
  }

  firewall { '100 Allow http and https access':
    dport   => [80, 443],
    proto   => tcp,
    action  => accept,
    require => Package['iptables-services']
  }
}

## EPEL Repo configuration ##
class cabriolet::commonrhel::yumRepo {
  file {'GPGKEY':
    ensure => 'present',
    source => 'puppet:///modules/cabriolet/epel/RPM-GPG-KEY-EPEL-7',
    path   => '/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7',
  }

  yumrepo { 'epelRelease':
    ensure         => 'present',
    descr          => 'Extra Packages for Enterprise Linux 7 - $basearch',
    enabled        => '1',
    failovermethod => 'priority',
    gpgcheck       => '1',
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7',
    mirrorlist     => 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch',
  }
}
