directory node.dots.gitroot

# dots is just the placeholder dir
git "#{node.dots.gitroot}/dots" do
  repository node.dots.gitrepo
  reference "master"
  action :sync
  notifies :run, "execute[Updating personal dotfiles]", :immediately
end

execute "Updating personal dotfiles" do
  cwd "#{node.dots.gitroot}/dots"
  command node.dots.dotcmd
  action :nothing
end
