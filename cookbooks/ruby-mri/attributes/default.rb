# EXAMPLE: 'http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p180.tar.gz'
default[:ruby_mri][:base_url] = 'http://ftp.ruby-lang.org/pub/ruby'
default[:ruby_mri][:major_version] = '1.9'
default[:ruby_mri][:full_version] = 'ruby-1.9.2-p180'
default[:ruby_mri][:install_path] = '/usr/local'
default[:ruby_mri][:dl_url] = [
  node.ruby_mri.base_url,
  node.ruby_mri.major_version,
  node.ruby_mri.full_version
] * '/' + '.tar.gz'
