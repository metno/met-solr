#
# Cookbook Name:: met-solr
# Recipe:: default
#
# Copyright (C) 2015 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'java' if node['met-solr']['install_java']
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

execute "install solr" do
    command "bash /tmp/install_solr_service.sh #{src_filepath} -p #{node['met-solr']['solr']['port']} -d #{node['met-solr']['solr']['data_dir'] } -i #{node['met-solr']['solr']['dir']}"
    not_if do
        File.directory?("#{node['met-solr']['solr']['dir']}/solr-#{node['met-solr']['solr']['version']}")
    end
end

firewall_rule "http" do
    port node['met-solr']['solr']['port']
    source '0.0.0.0/0'
    protocol :tcp
    action :allow
    only_if { node['met-solr']['open_firewall_port'] == true }
end


service 'solr' do
    action :nothing
end
