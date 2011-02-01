maintainer "Jeffrey ODell"
maintainer_email "jeffrey.odell@gmail.com"
description "basic debian lenny bootstrapping"
version "0.1"

%w{ debian }.each do |os|
    supports os
end
