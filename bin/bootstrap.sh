#!/bin/bash
CHEF_HOME=/var/chef
MY_BOOKS=$CHEF_HOME/cookbooks
GIT_REPO=git://github.com/jodell/cookbooks.git
ROOTDIR=$(cd `dirname $0` && cd .. && pwd)
DIRECTORY=$(cd `dirname $0` && pwd)

if [ $OSTYPE = 'linux-gnu' ]; then
  if [ -f /etc/debian_version ]; then
    DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
    if [ $DIST = 'Ubuntu' ]; then
      boot_debian
    elif [ $DIST = 'Debian' ]; then
      boot_debian
    fi
  elif [ -f /etc/redhat-release ]; then
    DIST=`cat /etc/redhat-release |sed s/\ release.*//`
    echo 'Redhat unsupported!'
  fi
elif [ `uname` = "Darwin" ]; then
  echo "OSX unsupported!"
else
  echo 'Unsupported OS!';
fi

if [[ $EUID -ne 0 ]]; then
  echo "Must be run as superuser"
  exit 1
fi

install_ruby () {
  RUBY=`which ruby`
  if [ $? -ne 0 ]; then
    echo "Bootstrapping for the installation of rubygems & chef"
    apt-get install -y -q git-core curl build-essential binutils-doc gcc autoconf flex bison \
      libreadline5-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev libopenssl-ruby1.8 ruby ruby-dev rubygems
  fi
}

# Skipping this until it's required again.
#
update_rubygems () {
  RUBYGEMS=rubygems-1.3.7
  RUBYGEMS_URL=http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz
  echo "Installing $RUBYGEMS"
  cd /tmp
  wget $RUBYGEMS_URL
  tar zxf $RUBYGEMS.tgz
  cd $RUBYGEMS
  ruby setup.rb
  gem update --system
} 

install_chef () {
  CHEF_SOLO=`which chef-solo`
  if [ $? -ne 0 ]; then
    echo "Installing Chef"
    gem install chef rake bundler --no-rdoc --no-ri
  else
    echo "Chef installed, skipping"
  fi
}

install_local_books () {
  if [[ -d $MY_BOOKS ]]; then
    echo "$MY_BOOKS already exists, skipping"
  else
    mkdir -p /var/chef
    echo "Grabbing $GIT_REPO"
    cd /var/chef && git clone $GIT_REPO && bundle install
  fi
}

info () {
  echo "You should be able to try applying a chef role or recipe now:"
  echo "> sudo chef-solo -c $ROOTDIR/solo.rb -j $ROOTDIR/roles/xen.json"
  echo "OR"
  echo "> rake run[recipe_or_role]"
}

boot_debian () {
  install_ruby
  install_chef
  install_local_books
  info
}
