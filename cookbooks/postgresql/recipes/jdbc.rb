directory node.postgresql.jdbc.dir do
  recursive true
end

remote_file "#{node.postgresql.jdbc.dir}/#{node.postgresql.jdbc.driver}" do
  source node.postgresql.jdbc.url
  not_if "test -f #{node.postgresql.jdbc.dir}/#{node.postgresql.jdbc.driver}"
end
