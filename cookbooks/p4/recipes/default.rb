directory '/usr/local/bin'

remote_file '/usr/local/bin/p4' do
  source 'http://www.perforce.com/downloads/perforce/r09.2/bin.linux26x86/p4'
  perms '0555'
  not_if 'which p4'
end

remote_file '/usr/local/bin/p4v' do
  source 'http://www.perforce.com/downloads/perforce/r09.2/bin.linux26x86/p4v.tgz'
  perms '0555'
  not_if 'which p4v'
end
