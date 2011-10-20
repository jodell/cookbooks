default[:webserver][:user]     = 'deploy'
default[:webserver][:srv_dir]  = '/srv' # Barbie Dreamhouse, Ken
default[:webserver][:scm_dir]  = ''
default[:webserver][:hostname] = false
#default[:webserver][:apps] = {
#  'app1' => 'git@github.com:user/app1.git'
#  'app2' => 'git@github.com:user/app2.git'
#}
default[:webserver][:app_dir_root]     = ''
default[:webserver][:current_symlink]  = false
default[:webserver][:release_init_dir] = '0'
default[:webserver][:app_dirs] = %w(
releases/0/tmp
releases/0/log
releases/0/public
shared/bundled_gems
shared/log
shared/tmp
repo
)
# REORG THIS
default[:webserver][:rails_env] = 'development'
default[:webserver][:rack_env]  = 'development'
default[:webserver][:using_ree] = false
default[:webserver][:using_mri] = false
default[:webserver][:using_rvm] = false
default[:webserver][:ref]       = 'master'

# HACK: when set, this doesn't drop the /etc/profile.d/ree-rails.sh helper
default[:webserver][:ree_rails_profile_off] = false
