%w(
openssh-server
sudo
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
).each { |p| package p }

execute "Setting locale to #{node.basic.locale}" do
  command "locale-gen #{node.basic.locale} && update-locale #{node.basic.locale}"
  only_if { platform?('ubuntu', 'debian') }
  not_if "locale | grep #{node.basic.locale}"
end

execute 'default editor' do
  command "update-alternatives --set editor #{node.basic.debian_editor}"
  only_if { platform?('ubuntu', 'debian') }
  not_if %{update-alternatives --query editor | grep "Value: #{node.basic.debian_editor}"}
end

user node.basic.user do
  shell '/bin/bash'
  home "/home/#{node.basic.user}"
  manage_home true
end

group 'sudo' do
  members [ node.basic.user ] 
  not_if { `groups | grep sudo` || ENV['USER'] == 'root' }
  only_if { platform?('ubuntu', 'debian') }
end
