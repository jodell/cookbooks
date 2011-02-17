#!/bin/bash
CHEF_HOME=/var/chef
MY_BOOKS=$CHEF_HOME/cookbooks
GIT_REPO=git://github.com/jodell/cookbooks.git
RUBYGEMS=rubygems-1.3.7
RUBYGEMS_URL=http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz
ROOTDIR=$(cd `dirname $0` && cd .. && pwd)

if [[ $EUID -ne 0 ]]; then
  echo "Must be run as superuser"
  exit 1
fi

RUBY=`which ruby`
if [ $? -ne 0 ]; then
  echo "Bootstrapping for the installation of rubygems & chef"
  apt-get install -y -q git-core curl
  apt-get install -y -q build-essential binutils-doc gcc autoconf flex bison
  apt-get install -y -q libreadline5-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev libopenssl-ruby1.8
  apt-get install -y -q ruby ruby-dev rubygems

  # This will probably be unnecessary at some point
  # RUBYGEM SETUP
  echo "Installing $RUBYGEMS"
  cd /tmp
  wget $RUBYGEMS_URL
  tar zxf $RUBYGEMS.tgz
  cd $RUBYGEMS
  ruby setup.rb
  gem update --system
else
  echo "Ruby installed, skipping"
fi

CHEF_SOLO=`which chef-solo`
if [ $? -ne 0 ]; then
  echo "Installing Chef"
  gem install chef rake bundler --no-rdoc --no-ri
else
  echo "Chef installed, skipping"
fi

if [[ -d $MY_BOOKS ]]; then
  echo "$MY_BOOKS already exists, skipping"
else
  mkdir -p /var/chef
  echo "Grabbing $GIT_REPO"
  cd /var/chef; git clone $GIT_REPO
fi

echo "You should be able to try applying a chef role or recipe now:"
echo "> sudo chef-solo -c $ROOTDIR/solo.rb -j $ROOTDIR/roles/xen.json"
echo "OR"
echo "> sudo rake run[xen]"
