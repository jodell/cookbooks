define :mri_gem, :source => nil, :version => nil do
  gem_package params[:name] do
    gem_binary "#{node[:ruby_mri][:install_path]}/bin/gem"
    source params[:source] if params[:source]
    version params[:version] if params[:version]
  end
end
