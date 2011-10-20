ruby 'See if this backs up external files' do
  code <<EoC
  #!/usr/bin/env ruby
  puts File.read("#{node.tester.file}")
EoC
  notifies :run, "execute[Delete the out of band file]", :immediately
  only_if "test -f #{node.tester.file}"
end

execute 'Delete the out of band file' do
  command "rm #{node.tester.file}"
  action :nothing
end
