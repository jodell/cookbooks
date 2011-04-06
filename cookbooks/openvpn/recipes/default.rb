package 'openvpn'

package 'resolvconf' do
  notifies :restart, 'service[networking]'
end

service 'networking'

remote_file "/etc/openvpn/#{node.openvpn.cert_file}" do
  source node.openvpn.cert_url
  mode "0644"
  not_if "test -f #{node.openvpn.cert_file}"
end

template '/etc/openvpn/client.conf' do
  source "client.conf.erb"
end
