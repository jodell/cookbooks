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
).each { |p| package p }

execute 'default editor' do
  command 'update-alternatives --set editor /usr/bin/vim.basic'
  only_if do platform?('ubuntu', 'debian') end
  not_if %{update-alternatives --query editor | grep "Value: /usr/bin/vim.basic"}
end
