define :pg_hba, :noop => true do
  conf = "/etc/postgresql/#{node.postgresql.version}/#{params[:name]}/pg_hba.conf"
  header = "\n#------------------------- Added by CHEF -------------------------------------"
  execute "Append a header to #{params[:name]}" do
    command %{echo "#{header}" >> #{conf}}
    not_if "grep 'Added by CHEF' #{conf}"
  end
  params[:add_lines].each do |line|
    execute "Appending to #{params[:name]}..." do
      command %{echo "#{line}" >> #{conf}}
      not_if %{grep "#{line}" #{conf}}
      notifies :reload, 'service[postgresql]'
    end
  end
end
