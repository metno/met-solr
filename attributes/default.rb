default['met-solr']['solr']['version']  = '5.1.0'
default['met-solr']['solr']['port']     = 8987
default['met-solr']['solr']['dir'] = "/opt"

# Directory for live / writable Solr files, such as logs, pid files, and index data; defaults to /var/solr-<version>
default['met-solr']['solr']['data_dir'] = "/var/solr-#{node['met-solr']['solr']['version']}"

# This is not offered with https
default['met-solr']['solr']['url'] = "http://apache.uib.no/lucene/solr/#{node['met-solr']['solr']['version']}/solr-#{node['met-solr']['solr']['version']}.tgz"

default['met-solr']['install_java'] = true

default['java']['install_flavor'] = 'openjdk'
default['java']['jdk_version'] = '7'
