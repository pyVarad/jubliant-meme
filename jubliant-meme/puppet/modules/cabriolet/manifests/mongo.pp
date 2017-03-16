class cabriolet::mongo {
  class { "cabriolet::mongo::setup": } ->
  class { "cabriolet::mongo::startService": }
}

class cabriolet::mongo::setup {
  file {'MongoRepoKeys':
    path => '/etc/yum.repos.d/mongodb-org-3.4.repo',
    source => 'puppet:///modules/cabriolet/mongo/mongodb-org-3.4.repo'
  }

  package { 'mongodb-org':
    ensure => '3.4.2-1.el7',
    require => File['MongoRepoKeys']
  }
}

class cabriolet::mongo::startService {
  service { 'mongod':
    ensure => running,
    enable => true
  }
}
