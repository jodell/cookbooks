package 'python-software-properties'

execute "apt-get update" do
  action :nothing
end

execute 'Adding backported repo' do
  command 'add-apt-repository ppa:chris-lea/node.js'
  not_if 'test -f /etc/apt/sources.list.d/chris-lea-node.js-*.list'
  notifies :run, resources("execute[apt-get update]"), :immediately
end

package 'nodejs'
