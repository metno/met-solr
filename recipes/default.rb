#
# Cookbook Name:: met-solr
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

if Chef::Config[:solo]
    raise 'This recipe requires Chef Search. Chef Solo does not support search.'
end

include_recipe 'java' if node['met-solr']['solr']['install_java']
src_filename = ::File.basename(node['met-solr']['solr']['url'])
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"

remote_file src_filepath do
    source node['met-solr']['solr']['url']
    action :create_if_missing
end

cookbook_file "/tmp/install_solr_service.sh" do
    source "install_solr_service.sh"
    mode 0755
    not_if do
        File.directory?("#{node['met-solr']['solr']['dir']}/solr-#{node['met-solr']['solr']['version']}")
    end
end

# Start solr with the -c opion. No way to specify this when running the installation script.
execute "enable_cloud" do
    command 'sed -i "s#/bin/solr \$SOLR_CMD#/bin/solr \$SOLR_CMD -c#g" /etc/init.d/solr'
    not_if 'grep "/bin/solr \$SOLR_CMD -c" /etc/init.d/solr'
    only_if { node['met-solr']['solr']['enable_cloud'] }
    action :nothing
end

execute "install solr" do
    command "bash /tmp/install_solr_service.sh #{src_filepath} -p #{node['met-solr']['solr']['port']} -d #{node['met-solr']['solr']['data_dir'] } -i #{node['met-solr']['solr']['dir']}"
    not_if do
        File.directory?("#{node['met-solr']['solr']['dir']}/solr-#{node['met-solr']['solr']['version']}")
    end
    notifies :run, "execute[enable_cloud]", :immediately
end

service 'solr' do
    action :nothing
    supports :status => true, :start => true, :stop => true, :restart => true
end

zookeepers = search(:node, "chef_environment:#{node.chef_environment} AND recipe:met-solr\\:\\:zookeeper")
zkstring = ""
zookeepers.each do |zookeeper|
    zkstring << zookeeper['ipaddress'] << ","
end

template "solar include script" do
    path "#{node['met-solr']['solr']['data_dir']}/solr.in.sh"
    source "solr.in.sh.erb"
    owner "solr"
    group "solr"
    mode "0755"
    variables :zkstring => zkstring
    notifies :restart, "service[solr]"
    only_if { node['met-solr']['solr']['enable_cloud'] }
end

#Add convinience link for testing
link "/var/solr" do
    to node['met-solr']['solr']['data_dir']
end
