maintainer "Jeffrey ODell"
maintainer_email "jeffrey.odell@gmail.com"
description "basic perforce installer"
version "0.1"

%w{ debian }.each do |os|
  supports os
end
