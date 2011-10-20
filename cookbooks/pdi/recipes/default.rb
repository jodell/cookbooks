include_recipe 'basic'
include_recipe 'java'
# base recipe

security_updates
package 'zip'

user node.pdi.user do
  shell '/bin/bash'
  home "/home/#{node.pdi.user}"
  manage_home true
end
# keyify task or recipe

directory node.pdi.scm_dir do
  recursive true
end

remote_file "/tmp/#{node.pdi.file}" do
  source node.pdi.url
  not_if "test -f /tmp/#{node.pdi.file}"
end

case node.pdi.edition
when /community|ce/i
  execute "Extracting pdi-ce to #{node.pdi.location}" do
    command "tar xf /tmp/#{node.pdi.file} -C #{node.pdi.location}"
    not_if "test -d #{node.pdi.location}/data-integration"
  end
when /enterprise|ee/i
  execute "Extracting pdi-ee to #{node.pdi.location}" do
    command #"tar xf /tmp/#{node.pdi.file} -C #{node.pdi.location}"
    not_if "test -d #{node.pdi.location}/data-integration"
  end
end

git node.pdi.scm_dir do
  repository node.pdi.repo
  reference node.pdi.ref
  action :sync
  enable_submodules true
end

execute "Changing ownership of #{node.pdi.scm_dir}" do
  command "chown -R #{node.pdi.user}:#{node.pdi.user} #{node.pdi.scm_dir}"
  action :run
end

ENV['JAVA_HOME'] ||= node.pdi.java_home 
ree_gem 'buildr'
