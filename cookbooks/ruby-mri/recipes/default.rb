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

local_file = node.ruby_mri.dl_url.split('/').last

remote_file "/tmp/#{local_file}" do
  source node.ruby_mri.dl_url
  not_if "test -f /tmp/#{local_file}"
end

bash 'Compiling and installing MRI' do
  cwd "/tmp"
  code <<-EOH
  tar zxvf #{local_file}
  cd #{local_file.sub(/\.tar\.gz/, '')} && ./configure && make && make install
  EOH
  not_if { File.directory? "/tmp/#{local_file.sub(/\.tar\.gz/, '')}" }
end

mri_gem 'bundler'
