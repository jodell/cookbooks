
basic = %w[ openssh-server sudo vim htop rsync ]

basic.each do |pkg|
  package pkg do
    action :install
  end
end





