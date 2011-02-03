package 'openvpn'

package 'resolvconf' do
  notifies :restart, 'service[networking]'
end

service 'networking'
