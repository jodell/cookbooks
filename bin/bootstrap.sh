#!/bin/bash
DIRECTORY=$(cd `dirname $0` && pwd)
ROOTDIR=$(cd `dirname $0` && cd .. && pwd)

if [ $OSTYPE = 'linux-gnu' ]; then
  if [ -f /etc/debian_version ]; then
    DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
    if [ $DIST = 'Ubuntu' ]; then
      $DIRECTORY/bootstrap-ubuntu.sh
    elif [ $DIST = 'Debian' ]; then
      $DIRECTORY/bootstrap-debian.sh
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
