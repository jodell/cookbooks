maintainer "Jeffrey ODell"
maintainer_email "jeffrey.odell@gmail.com"
description "Selenium RC installer"
version "0.1"

%w{ debian ubuntu }.each do |os|
  supports os
end
