
include_recipe 'lenny_bootstrap'

xen_pkgs = %w[
  xen-hypervisor-3.2-1-amd64
  xen-linux-system-2.6.26-1-xen-amd64
  xen-utils-3.2-1
  xenstore-utils
  xenwatch
  xen-shell
  xen-tools
]

xen_pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template '/etc/modules' do
  source 'modules.erb'
  mode 0644
  owner "root"
  group "root"
  variables(
    :max_loop => node[:xen][:modules][:max_loop]
  )
end

current_user = `env | grep SUDO_USER`.chomp.split(/=/).last

group 'xen' do
  members [ current_user ]
end

group 'adm' do
  members [ current_user ]
end

directory '/home/xen' do
  mode 1775
  group 'xen'
end

directory '/home/xen/boot/kernel' do
  recursive true
  action :create
end

directory '/home/xen/default' do
  action :create
end

directory '/etc/xen/auto' do
  action :create
end

template '/home/xen/default/default.cfg' do
  source 'default.cfg' # FIXME
end
