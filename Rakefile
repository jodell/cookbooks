require 'json'

def pwd
  File.expand_path(File.dirname(__FILE__))
end

def local_config
  pwd + '/solo.rb'
end

desc 'Ghetto chef bootstrapping, see bin/bootstrap.sh'
task :bootstrap do
  if `which chef-solo`.empty? # simplistic check
    sh pwd + '/bin/bootstrap.sh'
  end
end

desc 'Run a role or recipe from this repo'
task :run, [:role_or_recipe] => :bootstrap do |t, args|
  role = args[:role_or_recipe].match(/\.(json|rb)$/) ? args[:role_or_recipe] : (args[:role_or_recipe] + '.json')
  if File.exist? "#{pwd}/roles/#{role}"
    run = "#{pwd}/roles/#{role}"
  elsif File.directory? "#{pwd}/cookbooks/#{args[:role_or_recipe]}"
    File.open("/tmp/#{args[:role_or_recipe]}.json", 'w') do |f|
      f << { "recipes" => args[:role_or_recipe] }.to_json
    end
    run = "/tmp/#{args[:role_or_recipe]}.json"
  else
    abort "No cookbook or role found!"
  end
  sh "chef-solo -c #{local_config} -j #{run}"
end

desc 'Package these cookbooks'
task :pkg do
  version = (File.read('VERSION').chomp.to_f + 0.1).to_s
  sh "cd cookbooks && tar czvf ../pkg/cookbooks-#{version}.tar.gz *"
  File.open('VERSION', 'w') { |f| f << "#{version}" }
end

desc 'self-update this repo'
task :update do
  sh "git fetch && git pull"
end

desc 'Generate a new templated recipe'
task :generate, :name do |t, args|
  os          = ENV['os']     || 'debian' # space separated string
  maintainer  = ENV['author'] || "Jeffrey ODell"
  email       = ENV['email']  || "jeffrey.odell@gmail.com"
  description = ENV['desc']   || "<desc>"

  dirs = %w(recipes attributes)
  mkdirs = dirs.map { |dir| "cookbooks/#{args[:name]}/#{dir}" } * ' '
  touchfiles = dirs.map { |dir| "cookbooks/#{args[:name]}/#{dir}/default.rb" } * ' '
  sh "mkdir -p #{mkdirs} && touch #{touchfiles}"
  metadata =  File.open("cookbooks/#{args[:name]}/metadata.rb", 'w') do |f|
    f << <<-EOB
maintainer "#{maintainer}"
maintainer_email "#{email}"
description "#{description}"
version "0.1"

%w{ #{os} }.each do |os|
  supports os
end
EOB
  end
end
