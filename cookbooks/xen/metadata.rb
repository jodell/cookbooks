maintainer "Jeffrey ODell"
maintainer_email "jeffrey.odell@gmail.com"
description "basic debian lenny xen setup"
version "0.1"

depends "lenny_bootstrap"

%w{ debian }.each do |os|
  supports os
end

attribute 'xen/modules/max_loop',
  :display_name => '/etc/modules max_loop variable',
  :description => 'Variable for loop devices',
  :default => '64'
