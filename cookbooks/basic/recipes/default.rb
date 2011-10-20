execute 'Updating apt' do
  command 'apt-get update'
  only_if { platform?('ubuntu', 'debian') }
end

%w(
openssh-server
vim
htop
iotop
rsync
curl
git-core
screen
time
dnsutils
lsof
tree
language-pack-en-base
libsqlite3-dev
sqlite3
libcurl4-openssl-dev
vim-gtk
tcpdump
).each { |p| package p }

execute "Setting locale to #{node.basic.locale}" do
  command "locale-gen #{node.basic.locale} && update-locale LANG=#{node.basic.locale}"
  only_if { platform?('ubuntu', 'debian') }
  not_if "locale | grep LANG=#{node.basic.locale}"
end

ENV['LANG'] = node.basic.locale

execute 'Setting the default editor' do
  command "update-alternatives --set editor #{node.basic.editor}"
  only_if { platform?('ubuntu', 'debian') }
  not_if %{update-alternatives --query editor | grep "Value: #{node.basic.editor}"}
end

execute 'Setting the timezone' do
  command "echo '#{node.basic.tz}' > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata"
  only_if { platform?('ubuntu', 'debian') }
  not_if "grep '#{node.basic.tz}' /etc/timezone"
end

user node.basic.user do
  shell '/bin/bash'
  home "/home/#{node.basic.user}"
  manage_home true
end

include_recipe 'sudo'

node.basic.sysctl.each do |param, newval|
  sysctl param do
    val newval
  end
end
