#!/bin/bash
CHEF_HOME=/var/chef
MY_BOOKS=$CHEF_HOME/cookbooks
REPO_DEFAULT=git://github.com/jodell/cookbooks.git
GIT_REPO=${1:-$REPO_DEFAULT}
ROOTDIR=$(cd `dirname $0` && cd .. && pwd)
DIRECTORY=$(cd `dirname $0` && pwd)

# This is a hack for restored RS images having their their DNS/routes
# pulled out from under them via resolvconf (I think).
#
restart_networking() {
  # This may be more OS-specific than I think...
  /etc/init.d/networking restart
}

install_ruby() {
  RUBY=`which ruby`
  if [ $? -ne 0 ]; then
    echo "Bootstrapping for the installation of a system ruby & chef"
    apt-get update && apt-get install -y -q git-core curl build-essential binutils-doc gcc autoconf \
      flex bison libreadline5-dev zlib1g-dev libssl-dev libxml2-dev libxslt1-dev libopenssl-ruby1.8 \
      ruby ruby-dev rubygems
  fi
}

update_rubygems() {
  RUBYGEMS_VER=1.5.2
  RUBYGEMS="rubygems-${RUBYGEMS_VER}"
  RUBYGEMS_URL="http://production.cf.rubygems.org/rubygems/${RUBYGEMS}.tgz"
  GEMS=`gem --version | grep $RUBYGEMS_VER`
  if [ $? -ne 0 ]; then
    echo "Installing $RUBYGEMS"
    cd /tmp
    wget $RUBYGEMS_URL
    tar zxf $RUBYGEMS.tgz
    cd $RUBYGEMS
    ruby setup.rb
  else
    echo "Rubygems at $RUBYGEMS_VER, skipping"
  fi
}

install_chef() {
  CHEF_SOLO=`which chef-solo`
  if [ $? -ne 0 ]; then
    echo "Installing Chef"
    gem install rake bundler chef --no-rdoc --no-ri
  else
    echo "Chef installed, skipping"
  fi
}

get_latest_books() {
  if [[ -d $CHEF_HOME ]]; then
    echo "Updating $CHEF_HOME"
    cd $CHEF_HOME && git fetch && git pull && bundle install
  else
    echo "Grabbing $GIT_REPO"
    git clone $GIT_REPO $CHEF_HOME && cd $CHEF_HOME && bundle install
  fi
}

info() {
  echo "You should be able to try applying a chef role or recipe now:"
  echo "> sudo chef-solo -c $CHEF_HOME/solo.rb -j $CHEF_HOME/roles/xen.json"
  echo "OR"
  echo "> cd $CHEF_HOME && rake run[recipe_or_role]"
}

boot_debian() {
  restart_networking
  install_ruby
  update_rubygems
  install_chef
  get_latest_books
  info
}

if [[ $EUID -ne 0 ]]; then
  echo "Must be run as superuser"
  exit 1
fi

if [ $OSTYPE = 'linux-gnu' ]; then
  if [ -f /etc/debian_version ]; then
    DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F= '{ print $2 }'`
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
