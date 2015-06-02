default['met-solr']['solr']['version']  = '5.1.0'
default['met-solr']['solr']['port']     = 8987
default['met-solr']['solr']['dir'] = "/opt"
default['met-solr']['solr']['enable_cloud'] = true #Setting this launches solr in cloud mode.

# Directory for live / writable Solr files, such as logs, pid files, and index data; defaults to /var/solr-<version>
default['met-solr']['solr']['data_dir'] = "/var/solr-#{node['met-solr']['solr']['version']}"

# This is not offered with https
default['met-solr']['solr']['url'] = "http://apache.uib.no/lucene/solr/#{node['met-solr']['solr']['version']}/solr-#{node['met-solr']['solr']['version']}.tgz"

default['met-solr']['solr']['install_java'] = true

default['met-solr']['solr']['config_zookeeper']  = true

default['met-solr']['zookeeper']['install_java'] = true
default['met-solr']['zookeeper']['version']  = '3.4.6'
default['met-solr']['zookeeper']['url'] = "http://apache.uib.no/zookeeper/stable/zookeeper-#{node['met-solr']['zookeeper']['version']}.tar.gz"
default['met-solr']['zookeeper']['user'] = 'zookeeper'
default['met-solr']['zookeeper']['install_dir'] = '/opt'
default['met-solr']['zookeeper']['data_dir'] = "/var/zookeeper-#{node['met-solr']['zookeeper']['version']}"
default['met-solr']['zookeeper']['log_dir'] = "#{node['met-solr']['zookeeper']['data_dir']}/logs"

default['java']['install_flavor'] = 'openjdk'
default['java']['jdk_version'] = '7'
