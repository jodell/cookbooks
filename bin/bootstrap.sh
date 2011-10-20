#!/bin/bash
CHEF_HOME=/var/chef
MY_BOOKS=$CHEF_HOME/cookbooks
REPO_DEFAULT=git://github.com/jodell/cookbooks.git
GIT_REPO=${1:-$REPO_DEFAULT}
ROOTDIR=$(cd `dirname $0` && cd .. && pwd)
DIRECTORY=$(cd `dirname $0` && pwd)

install_ruby () {
  RUBY=`which ruby`
  if [ $? -ne 0 ]; then
    echo "Bootstrapping for the installation of rubygems & chef"
    /usr/bin/aptitude install -y -q build-essential bison openssl libreadline6 libreadline6-dev curl \
      git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev \
      libxslt-dev autoconf libc6-dev ncurses-dev ruby-dev ruby rubygems libopenssl-ruby1.8 flex gcc \
      binutils-doc
  fi
}

update_rubygems () {
  RUBYGEMS=rubygems-1.5.2
  RUBYGEMS_URL=http://production.cf.rubygems.org/rubygems/rubygems-1.5.2.tgz
  echo "Installing $RUBYGEMS"
  cd /tmp
  wget $RUBYGEMS_URL
  tar zxf $RUBYGEMS.tgz
  cd $RUBYGEMS
  ruby setup.rb
  #gem update --system
}

install_chef () {
  CHEF_SOLO=`which chef-solo`
  if [ $? -ne 0 ]; then
    echo "Installing Chef"
    gem install rake bundler chef --no-rdoc --no-ri
  else
    echo "Chef installed, skipping"
  fi
}

install_local_books () {
  if [[ -d $MY_BOOKS ]]; then
    echo "$MY_BOOKS already exists, skipping"
  else
    echo "Grabbing $GIT_REPO"
    git clone $GIT_REPO $CHEF_HOME && cd $CHEF_HOME && (bundle check || bundle install)
  fi
}

info () {
  echo "You should be able to try applying a chef role or recipe now:"
  echo "> sudo chef-solo -c $CHEF_HOME/solo.rb -j $CHEF_HOME/roles/xen.json"
  echo "OR"
  echo "> cd $CHEF_HOME && rake run[recipe_or_role]"
}

boot_debian () {
  install_ruby
  update_rubygems
  install_chef
  install_local_books
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
