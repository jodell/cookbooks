maintainer "Jeffrey ODell"
maintainer_email "jeffrey.odell@gmail.com"
description "Basic layout for a generic web server"
version "0.1"

%w{ debian }.each do |os|
  supports os
end
