#
# Cookbook Name:: met-solr
# Recipe:: zookeeper
#
# Copyright (C) 2015 YOUR_NAME
#
#

if Chef::Config[:solo]
    raise 'This recipe requires Chef Search. Chef Solo does not support search.'
end

include_recipe 'java' if node['met-solr']['zookeeper']['install_java']
src_filename = ::File.basename(node['met-solr']['zookeeper']['url'])
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"

remote_file src_filepath do
  source node['met-solr']['zookeeper']['url']
  action :create_if_missing
end

user node['met-solr']['zookeeper']['user'] do
    comment 'user running zookeeper'
    system true
end

execute "extract zookeeper" do
    Chef::Log.info("Unpacking zookeeper")
    command "tar xvzf #{src_filepath}"
    cwd node['met-solr']['zookeeper']['install_dir']
    action :run
    not_if { ::File.exists?("/opt/zookeeper-#{node['met-solr']['zookeeper']['version']}") }
end

directory "#{node['met-solr']['zookeeper']['install_dir']}/zookeeper-#{node['met-solr']['zookeeper']['version']}" do
    recursive true
    user  node['met-solr']['zookeeper']['user']
    group node['met-solr']['zookeeper']['user']
    mode '0755'
end

directory node['met-solr']['zookeeper']['data_dir'] do
    user  node['met-solr']['zookeeper']['user']
    group node['met-solr']['zookeeper']['user']
    mode '0755'
end

link "#{node['met-solr']['zookeeper']['install_dir']}/zookeeper" do
    to "#{node['met-solr']['zookeeper']['install_dir']}/zookeeper-#{node['met-solr']['zookeeper']['version']}"
end

template "zookeeper init script" do
    path "/etc/init.d/zookeeper"
    source "zookeeper-init.sh.erb"
    owner "root"
    group "root"
    mode "0755"
end

service "zookeeper" do
    supports :restart => true, :start => true, :stop => true
    action [ :enable]
    ignore_failure true #Restarting the server failes the first (ie stop fails) time, since it's not running yet.
end

myid = node['ipaddress'].dup
file "#{node['met-solr']['zookeeper']['data_dir']}/myid" do
    content myid.delete! '.'
    owner node['met-solr']['zookeeper']['user']
    group node['met-solr']['zookeeper']['user']
    mode '640'
end

# Do twice. One for initial install, and one when config changes
zookeepers = search(:node, "chef_environment:#{node.chef_environment} AND recipe:met-solr\\:\\:zookeeper")
template "zookeeper config" do
    path "#{node['met-solr']['zookeeper']['install_dir']}/zookeeper/conf/zoo.cfg"
    source "zoo.cfg.erb"
    owner node['met-solr']['zookeeper']['user']
    group node['met-solr']['zookeeper']['user']
    mode "0755"
    variables :zookeeper_servers => zookeepers
    notifies :restart, "service[zookeeper]"
end

zookeepers.each do |zookeeper|
    #Allow connection to management ports from other zookeepers
    firewall_rule "zookeeper #{zookeeper['ipaddress']}" do
        port 2888
        source zookeeper['ipaddress']
        protocol :tcp
        action :allow
    end

    firewall_rule "zookeeper #{zookeeper['ipaddress']}" do
        port 3888
        source zookeeper['ipaddress']
        protocol :tcp
        action :allow
    end
end
