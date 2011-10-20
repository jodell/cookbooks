package 'sendmail'

scm_dir  = node[:webserver][:apps][:bigtuna][:scm_dir] || node.webserver.scm_dir
srv_dir  = node[:webserver][:apps][:bigtuna][:srv_dir] || node.webserver.srv_dir
app_user = node[:webserver][:apps][:bigtuna][:user]    || node.webserver.user

# NOTE: SSH Keys
# This is an intentional manual step for the moment.  Grab ~centro/.ssh/id_dsa* from an existing
# CI box and drop them into the home of your CI user.  Then add that key to the deploy keys section
# in your github project, ala: https://github.com/centro/pickle_factory/admin/keys.  Then make sure
# your project has a post-receive hook to hit the CI box you're setting up.

# One-time deploy hack
execute 'Deploy HACK' do
  command [
    "cp -R #{srv_dir}/bigtuna/#{scm_dir}/* #{srv_dir}/bigtuna/current",
    "rm -rf #{srv_dir}/bigtuna/releases/0/.git"
  ] * ' && '
  user app_user
  environment 'HOME' => "/home/#{app_user}"
  not_if "test -d #{srv_dir}/bigtuna/current/app"
  action :run
end

node.bigtuna.apps.each do |app|
  directory "#{srv_dir}/bigtuna/shared/#{app}"

  Dir["/etc/centro/#{app}/*"].each do |file|
    link "#{srv_dir}/bigtuna/shared/#{app}/#{File.basename(file)}" do
      to file
      owner app_user
      group app_user
    end
  end
end

%w(email bigtuna database).each do |config|
  local_config "#{srv_dir}/bigtuna/shared/config/#{config}.yml" do
    app 'bigtuna'
    root '/etc/centro'
    source "#{config}.yml.erb"
    vars = node['bigtuna'][(config == 'bigtuna' ? 'config' : config)]
    vars['env'] = node.bigtuna.rails_env
    variables(vars)
    owner app_user
    group app_user
    notifies 'Deploy HACK', :immediately
  end
  link "#{srv_dir}/bigtuna/current/config/#{config}.yml" do
    to "#{srv_dir}/bigtuna/shared/config/#{config}.yml"
    owner app_user
    group app_user
  end
end

env_cmd = "export RAILS_ENV=#{node.bigtuna.rails_env}; (bundle check || bundle install) && bundle exec "

execute 'Bootstrap the database' do
  cwd "#{srv_dir}/bigtuna/current"
  command env_cmd + "rake db:schema:load"
  user app_user
  environment 'HOME' => "/home/#{app_user}"
  not_if "test -f #{srv_dir}/bigtuna/current/#{node.bigtuna.database.name}"
  action :run
end

execute '(re)start DJ' do
  cwd "#{srv_dir}/bigtuna/current"
  command env_cmd + "script/delayed_job restart"
  user app_user
  environment 'HOME' => "/home/#{app_user}"
  action :run
end

template "/etc/apache2/sites-available/#{node.bigtuna.host}.conf" do
  source 'bigtuna.conf.erb'
  owner 'root'
  group 'root'
  mode 0755
end

apache_site "#{node.bigtuna.host}.conf" do
  enable node.bigtuna.apache.enable
end
