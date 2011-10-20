package 'openvpn'

package 'resolvconf' do
  notifies :restart, 'service[networking]'
  notifies :run, "execute[Ensure resolvconf defaults to the original nameservers]"
end

service 'networking'

template "/etc/openvpn/#{node.openvpn.cert_file}" do
  source 'pkcs.p12'
  action :create_if_missing
  owner 'root'
  group 'root'
  mode 0755
end

template '/etc/openvpn/client.conf' do
  source "client.conf.erb"
end

ruby 'Conditional startup of vpn client' do
  code <<EoC
#!/usr/bin/env ruby
require 'expect'
require 'pty'
File.read('#{node.openvpn.temp_auth_file}').strip.match(/(.*?):(.*)/)
PTY.spawn('/etc/init.d/openvpn restart') do |r, w, pid|
  r.expect /(.*)Enter Auth Username:/
  w.puts "\#{$1}\\n"
  r.expect /(.*)Enter Auth Password:/
  w.puts "\#{$2}\\n"
  r.read
end
EoC
  notifies :run, "execute[Deleting the temporary authfile]", :immediately
  not_if "ps ax | grep openv[p]n"
  only_if "test -f #{node.openvpn.temp_auth_file}"
end

execute "Ensure resolvconf defaults to the original nameservers" do
  command "ln -sf /etc/resolvconf/resolv.conf.d/original /etc/resolvconf/resolv.conf.d/tail"
  not_if "test -L /etc/resolvconf/resolv.conf.d/tail"
end

execute "Deleting the temporary authfile" do
  command "rm #{node.openvpn.temp_auth_file}"
  action :nothing
end
