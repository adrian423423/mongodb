#
# Class mongodb::org 
#
class mongodb::org {
  if ($osfamily == 'RedHat' or $operatingsystem == 'Amazon') {
    yumrepo { 'org':
      baseurl        => "http://downloads-distro.mongodb.org/repo/redhat/os/$architecture",
      failovermethod => 'priority',
      enabled        => '1',
      gpgcheck       => '0',
      descr          => 'org Repository',
      notify         => Exec['yum-check-update-mongo'],
    }
   
    # Puppet bug with yum provider, need to execute a command at the end to return 0
    exec { 'yum-check-update-mongo':
      command     => 'yum check-update;echo $?',
      path        => '/bin:/usr/bin:/usr/local/bin',
      tries       => 5,
      logoutput   => true,
      refreshonly => true,
    }
  } elsif ($osfamily == 'Debian') {
    case $::operatingsystem {
      'Debian': { 
        $source = 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist org' 
      }
      'Ubuntu': { 
        $source = 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist org' 
      }
    }

    exec { 'apt-key-mongo':
      command   => 'apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10',
      path      => '/bin:/usr/bin:/usr/local/bin',
      logoutput => true,
      unless    => 'apt-key list | grep org',
    }
    
    exec { 'apt-source-mongo':
      command   => "echo \"${source}\" > /etc/apt/sources.list.d/org.list",
      path      => '/bin:/usr/bin:/usr/local/bin',
      logoutput => true,
      unless    => 'cat /etc/apt/sources.list | grep org',
      require   => Exec['apt-key-mongo'],
    }
    
    exec { 'apt-update-mongo':
      command   => 'apt-get update',
      path      => '/bin:/usr/bin:/usr/local/bin',
      logoutput => true,
      require   => Exec['apt-source-mongo']
    }
  }
}