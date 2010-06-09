
require 'rake'

task :default => :install

desc 'default cookbook to install via chef-solo'
task :install do
  sh 'chef-solo -c test.rb -j test.json'
end

@os = 'debian' # space separated string
@maintainer = "Jeffrey ODell"
@maintainer_email = "jeffrey.odell@gmail.com"
@description = "basic debian lenny bootstrapping"


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
