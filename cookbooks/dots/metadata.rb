maintainer "Jeffrey ODell"
maintainer_email "jeffrey.odell@gmail.com"
description "A slightly generic helper recipe for bootstrapping dots files"
version "0.1"

%w{ debian }.each do |os|
  supports os
end
