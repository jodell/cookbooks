include_recipe 'centro_base'
include_recipe 'webserver'

################################################################################
# Gem package deps:
# - memcached
# - johnson
%w(
libmemcached-dev
libsasl2-dev
zip
).each { |pkg| package pkg }

template "/etc/apache2/sites-available/#{node.webserver.host}.conf" do
  source 'finance-test.transis.net.conf.erb'
  owner 'root'
  group 'root'
  mode 0755
end

link "/etc/apache2/sites-enabled/#{node.webserver.host}.conf" do
  to "/etc/apache2/sites-available/#{node.webserver.host}.conf"
  owner 'root'
  group 'root'
  notifies :reload, 'service[apache2]'
end
