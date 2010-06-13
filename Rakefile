require 'rake'

task :default => :'cook:default'
task :sel => :'cook:selenium'

@version = IO.readlines('VERSION').first.chomp

task :pkg do
  books = FileList['*'].reject { |f| !File.directory?(f) || f.match(/pkg/) }
  @version = (@version.to_f + 0.1).to_s
  sh "tar czvf pkg/cookbooks-#{@version}.tar.gz #{books * ' '}"
  File.open('VERSION', 'w') { |f| f << "#{@version}\n" }
end

task :version do
  puts @version
end

desc 'Ghetto chef bootstrapping, see bin/lenny-bootstrap.sh'
task :pre do
  # Replaced by bin/bootstrap-lenny.sh
  unless File.exists?('/var/chef/cookbooks') # simplistic check
    sh 'sudo apt-get install -y -q rubygems ruby ruby-dev libopenssl-ruby1.8 build-essential vim tree htop git-core'
    cmd = [
      'cd /tmp',
      'wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz',
      'tar zxf rubygems-1.3.7.tgz',
      'cd rubygems-1.3.7',
      'sudo ruby setup.rb',
      'sudo gem update --system',
    ]
    sh cmd * ';'
    sh 'sudo gem install chef'
    sh 'sudo mkdir -p /var/chef'
    sh 'cd /var/chef; git clone git://github.com/jodell/cookbooks.git'
  end
end

task :xen => :pre do
  sh 'sudo chef-solo -j /var/chef/cookbooks/xen.json'
end

namespace :cook do
  desc 'default cookbook to install via chef-solo'
  task :default do
    sh 'chef-solo -c solo.rb -j solo.json'
  end

  desc 'cookbook for a headless selenium-rc node'
  task :selenium do
    sh 'chef-solo -c sel_node.rb -j sel_node.json'
  end
end

@os = 'debian' # space separated string
@maintainer = "Jeffrey ODell"
@maintainer_email = "jeffrey.odell@gmail.com"
@description = "<desc>"

namespace :rec do
  desc 'generate a new recipe dir with $name'
  task :new do
    raise "Expected $name!" unless @name = ENV['name']
    sh "mkdir -p #{@name}/recipes"
    metadata = <<-EOB
maintainer "#{@maintainer}"
maintainer_email "#{@maintainer_email}"
description "#{@description}"
version "0.1"

%w{ #{@os} }.each do |os|
  supports os
end
EOB
    File.open("#{@name}/metadata.rb", 'w') do |f|
      f << metadata
    end
    sh "touch #{@name}/recipes/default.rb"
  end
end

