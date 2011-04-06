maintainer "Jeffrey ODell"
maintainer_email "jeffrey.odell@gmail.com"
description "This is just the openvpn client recipe. See https://github.com/opscode/cookbooks for a server configuration."
version "0.1"

%w{ ubuntu }.each do |os|
  supports os
end
