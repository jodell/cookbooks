%w(
build-essential
bison
openssl
libreadline6
libreadline6-dev
curl
git-core
zlib1g
zlib1g-dev
libssl-dev
libyaml-dev
libsqlite3-0
libsqlite3-dev
sqlite3
libxml2-dev
libxslt1-dev
autoconf
libc6-dev
libncurses5-dev
).each { |p| package p }

#"/usr/bin/aptitude install build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev"

execute 'Grab the RVM installer' do
  command 'curl -s https://rvm.beginrescueend.com/install/rvm | bash'
  not_if 'which rvm'
end

template '/etc/profile.d/rvm.sh' do
  source 'rvm.sh.erb'
  owner 'root'
  group 'root'
  mode 0755
end if node.rvm.default_rvm

node.rvm.rubies.each do |ruby|
  bash "Installing #{ruby} via RVM" do
    code <<-EoC
    source /usr/local/rvm/scripts/rvm
    rvm list | grep #{ruby} || rvm install #{ruby}
    EoC
  end
end

bash "Defaulting to #{node.rvm.default_ruby}" do
  code <<-EoC
  source /usr/local/rvm/scripts/rvm
  rvm list | grep #{node.rvm.default_ruby} || rvm --default use #{node.rvm.default_ruby}
  EoC
end if node.rvm.default_ruby
