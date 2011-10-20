package 'python-software-properties'

execute "apt-get update" do
  action :nothing
end

execute 'Adding backported repo' do
  command 'add-apt-repository ppa:pitti/postgresql'
  not_if 'test -f /etc/apt/sources.list.d/pitti-postgresql-*.list'
  notifies :run, resources("execute[apt-get update]"), :immediately
end
