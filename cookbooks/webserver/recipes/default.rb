user node.webserver.user do
  shell '/bin/bash'
  home "/home/#{node.user}"
  manage_home true
end

directory node.webserver.srv_dir

node.webserver.apps.each do |app|
  app_dir = "#{node.webserver.srv_dir}/#{app}"
  directory app_dir do
    owner node.webserver.user
    group node.webserver.user
    mode 0775
    recursive true
  end

  node.webserver.app_dirs.each do |dir|
    directory "#{app_dir}/#{dir}" do
      owner node.webserver.user
      group node.webserver.user
      mode 0775
      recursive true
    end
  end

  link "#{app_dir}/current" do
    to "#{app_dir}/releases/#{node.webserver.release_init_dir}"
    owner node.webserver.user
    group node.webserver.user
  end
end
