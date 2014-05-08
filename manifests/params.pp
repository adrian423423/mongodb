#
# Class mongo::params 
#
class mongodb::params() {
  
  case $::operatingsystem {
    /(Amazon|CentOS|Fedora|RedHat)/: {
      $mongo_org        = 'mongodb-org'
      $mongo_org_server = 'mongodb-org-server'
      $mongo_user         = 'mongod'
      $mongo_service      = 'mongod'
      $mongo_config       = 'mongod.conf'
      $mongo_log          = '/var/log/mongo'
      $mongo_path         = '/var/lib/mongo'
    }
    /(Debian|Ubuntu)/: {
      $mongo_org        = 'mongodb-org'
      $mongo_org_server = undef
      $mongo_user         = 'mongodb'
      $mongo_service      = 'mongodb'
      $mongo_config       = 'mongodb.conf'
      $mongo_log          = '/var/log/mongodb'
      $mongo_path         = '/var/lib/mongodb'
    }
    default: {
      fail('Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}')
    }
  }
}