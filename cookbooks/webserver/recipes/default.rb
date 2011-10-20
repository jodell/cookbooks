include_recipe 'openvpn'
# base recipe

# FIXME: Fix this shit
include_recipe 'rvm' if node.webserver.using_rvm
include_recipe 'ruby-mri' if node.webserver.using_mri
include_recipe (node.webserver.using_ree ? 'ruby_enterprise' : 'apache2')

template "/etc/profile.d/ree-rails.sh" do
  source 'ree-rails.sh.erb'
  owner 'root'
  group 'root'
  mode 0755
end unless node['webserver']['ree_rails_profile_off']

directory node.webserver.srv_dir

%w(default 000-default).each do |site|
  apache_site site do
    enable false
  end
end

node.webserver.apps.each do |app, meta|
  app_dir     = "#{meta['srv_dir'] || node.webserver.srv_dir}/#{app}"
  scm_dir     = "#{app_dir}/#{meta['scm_dir'] || node.webserver.scm_dir}"
  shared_dir  = "#{app_dir}/shared"
  app_user    = meta['user']        || node.webserver.user
  app_dirs    = meta['app_dirs']    || node.webserver.app_dirs
  shared_dirs = meta['shared_dirs'] || node.webserver.shared_dirs
  rails_env   = meta['rails_env']   || node.webserver.ref
  ref         = meta['ref']         || node.webserver.ref
  repo        = meta['repo']

  user app_user do
    shell '/bin/bash'
    home "/home/#{node.webserver.user}"
    manage_home true
  end

  #keyify task or recipe

  directory scm_dir do
    owner app_user
    group app_user
    mode 0775
    recursive true
  end

  git scm_dir do
    repository repo
    reference ref
    action :sync
    enable_submodules true
  end

  app_dirs.each do |dir|
    directory "#{app_dir}/#{dir}" do
      owner app_user
      group app_user
      mode 0775
      recursive true
    end
  end

  shared_dirs.each do |dir|
    directory "#{app_dir}/shared/#{dir}" do
      owner app_user
      group app_user
      mode 0775
      recursive true
    end
  end

  # FIXME: Use a definition here
  ree_path = "export PATH=#{node.ruby_enterprise.install_path}/bin:$PATH;"
  mri_path = "export PATH=#{node.ruby_mri.install_path}/bin:$PATH;"
  rvm_path = "source /usr/local/rvm/script/rvm;" # HACK
  ruby_path = ree_path if node.webserver.using_ree
  ruby_path = mri_path if node.webserver.using_mri
  ruby_path = rvm_path if node.webserver.using_rvm

  execute "Bundling #{app}..." do
    cwd scm_dir
    command [
      "#{ruby_path} bundle check || bundle install ",
      "#{rails_env == 'production' ? '--deployment --without test examples development' : '' }"
    ].join
    action :run
  end

  link "#{app_dir}/current" do
    to "#{app_dir}/releases/#{node.webserver.release_init_dir}"
    owner app_user
    group app_user
  end if node.webserver.current_symlink

  # NOTE: Would prefer to not have to do this.
  execute "Set #{app_dir} ownership to #{app_user}" do
    command "chown -R #{app_user}:#{app_user} #{app_dir}"
    action :run
    notifies :reload, 'service[apache2]'
  end
end
