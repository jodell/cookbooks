define :add_to_system_env, :noop => nil do
  execute "Adding #{params[:name]} to /etc/environment" do
    command "echo '#{params[:name]}' >> /etc/environment"
    not_if "grep #{params[:name]} /etc/environment"
  end
end
