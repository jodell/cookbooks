default[:webserver][:user] = 'deploy'
default[:webserver][:srv_dir] = '/srv' # Barbie Dreamhouse, Ken
default[:webserver][:apps] = %w(
app1
app2
)
default[:webserver][:app_dirs] = %w(
releases/0/tmp
releases/0/log
releases/0/public
shared/bundled_gems
shared/log
shared/tmp
repo
)
