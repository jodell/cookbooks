
basic = %w[ openssh-server sudo vim htop rsync curl git-core ]

basic.each do |pkg|
  package pkg do
    action :install
  end
end

directory '~/git' do
  not_if 'test -d ~/git'
end
