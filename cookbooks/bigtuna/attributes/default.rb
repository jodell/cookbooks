default[:bigtuna][:apache][:enable] = true
default[:bigtuna][:rails_env]       = 'development'
default[:bigtuna][:public_dir]      = 'bigtuna/current/public'
default[:bigtuna][:host]            = '<some host>'
default[:bigtuna][:apps_dir]        = '/etc/some_dir'

default[:bigtuna][:database][:adapter] = 'sqlite3'
default[:bigtuna][:database][:host]    = 'localhost'
default[:bigtuna][:database][:name]    = 'bigtuna'
default[:bigtuna][:database][:pool]    = '5'

default[:bigtuna][:config][:read_only]     = false
default[:bigtuna][:config][:github_secure] = '<some url>'
default[:bigtuna][:config][:url_host]      = '<some host>'
default[:bigtuna][:config][:ajax_reload]   = false
default[:bigtuna][:config][:build_dir]     = 'builds'

default[:bigtuna][:email][:address]  = '<some address>'
default[:bigtuna][:email][:port]     = '25'
default[:bigtuna][:email][:domain]   = 'nil'
default[:bigtuna][:email][:username] = '<some user>'
default[:bigtuna][:email][:password] = '<some pass>'

default[:bigtuna][:apps] = %w(sample_app1 sample_app2)

default[:bigtuna][:passenger_opts] = [
  "PassengerMaxRequests 100",
  "PassengerMaxInstancesPerApp 1",
  "PassengerStatThrottleRate 60"
]
