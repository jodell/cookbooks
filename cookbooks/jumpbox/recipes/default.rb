# base role

security_updates

# keyify task/recipe

directory "#{node.jumpbox.dsh.path}/group" do
  recursive true
end

node.jumpbox.dsh.groups.each do |group, boxes|
  template "#{node.jumpbox.dsh.path}/group/#{group}" do
    owner 'root'
    mode '0644'
    source 'dsh-groups.erb'
    variables(:boxes => boxes)
  end
end
