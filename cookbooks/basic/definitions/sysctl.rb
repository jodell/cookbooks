define :sysctl, :noop => nil do
  execute "Changing kernel param #{params[:name]} to #{params[:val]}" do
    command "sysctl -w #{params[:name]}=#{params[:val]}"
    not_if "sysctl #{params[:name]} | grep #{params[:val]}"
  end
end
