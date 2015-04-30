def whyrun_supported?
    true
end

action :create do
    core_dir = node['met-solr']['solr']['data_dir'] + "/data/" + new_resource.name
    remote_directory core_dir do
        source new_resource.source
        files_backup 0
        files_owner "solr"
        files_group "solr"
        files_mode "0600"
        owner "solr"
        group "solr"
        mode "0755"
        notifies :restart, "service[solr]"
    end
    # My state has changed so I'd better notify observers
    new_resource.updated_by_last_action(true)
end
