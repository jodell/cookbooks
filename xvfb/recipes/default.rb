

# Resuse from opscode
# include_recipe 'java'

pkgs = %w( xvfb imagemagick )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

