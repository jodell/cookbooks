#
# Cookbook Name:: postgresql
# Attributes:: postgresql
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
case platform
when "debian"
  if platform_version.to_f == 5.0
    default[:postgresql][:version] = "8.3"
  elsif platform_version =~ /.*sid/
    default[:postgresql][:version] = "8.4"
  end
  set[:postgresql][:dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"
  default[:postgresql][:local_trust] = 'ident'

when "ubuntu"
  if platform_version.to_f <= 9.04
    default[:postgresql][:version] = "8.3"
  else
    default[:postgresql][:version] = "8.4"
  end
  set[:postgresql][:dir] = "/etc/postgresql/#{node[:postgresql][:version]}/main"
  default[:postgresql][:local_trust] = 'ident'

when "fedora"
  if platform_version.to_f <= 12
    default[:postgresql][:version] = "8.3"
  else
    default[:postgresql][:version] = "8.4"
  end
  set[:postgresql][:dir] = "/var/lib/pgsql/data"

when "redhat","centos"
  default[:postgresql][:version] = "8.4"
  set[:postgresql][:dir] = "/var/lib/pgsql/data"

when "suse"
  if platform_version.to_f <= 11.1
    default[:postgresql][:version] = "8.3"
  else
    default[:postgresql][:version] = "8.4"
  end
  set[:postgresql][:dir] = "/var/lib/pgsql/data"

else
  default[:postgresql][:version] = "8.4"
  set[:postgresql][:dir]            = "/etc/postgresql/#{node[:postgresql][:version]}/main"
end

default[:postgresql][:port] = '5432'
default[:postgresql][:jdbc][:dir] = '/usr/share/java'
default[:postgresql][:pg_config_opts] = {}
default[:postgresql][:pg_hba_opts] = {}

case node[:postgresql][:version]
when '8.4'
  default[:postgresql][:jdbc][:driver] = 'postgresql-8.4-702.jdbc4.jar'
  default[:postgresql][:jdbc][:url] = "http://jdbc.postgresql.org/download/#{node.postgresql.jdbc.driver}"
when /9\.(0|04)/
  default[:postgresql][:jdbc][:driver] = 'postgresql-9.0-801.jdbc4.jar'
  default[:postgresql][:jdbc][:url] = "http://jdbc.postgresql.org/download/#{node.postgresql.jdbc.driver}"
end
