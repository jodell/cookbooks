basic = %w(
openssh-server
sudo
vim
htop
rsync
)

basic.each { |pkg| package pkg }
