

pkgs = %w( xvfb imagemagick )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end
