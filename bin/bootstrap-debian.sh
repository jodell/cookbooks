#!/usr/bin/env bash

CHEF_HOME=/var/chef
MY_BOOKS=$CHEF_HOME/cookbooks
GIT_REPO=git://github.com/jodell/cookbooks.git
RUBYGEMS=rubygems-1.3.7
RUBYGEMS_URL=http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz

if [[ $EUID -ne 0 ]]; then
    echo "Must be run as superuser"
    exit 1
fi

if [[ -d $MY_BOOKS ]]; then
    echo "$MY_BOOKS already exists, exiting"
    exit 1
fi

echo "Bootstrapping for the installation of rubygems & chef"
sudo apt-get install -y -q rubygems ruby ruby-dev libopenssl-ruby1.8 build-essential tree git-core

echo "Installing $RUBYGEMS"
cd /tmp
wget $RUBYGEMS_URL
tar zxf $RUBYGEMS.tgz
cd $RUBYGEMS
ruby setup.rb
gem update --system

echo "Installing Chef"
gem install chef
mkdir -p /var/chef

echo "Grabbing $GIT_REPO"
cd /var/chef; git clone $GIT_REPO

echo "Try chef-solo now:"
echo "> sudo chef-solo -j $GIT_REPO/xen.json"
