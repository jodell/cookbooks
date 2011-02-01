


pkgs = %w( ruby ruby-dev rake rubygems )

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end
