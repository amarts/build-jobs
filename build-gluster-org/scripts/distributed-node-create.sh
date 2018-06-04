#!/bin/sh

MAX_ATTEMPTS=3
set -e

# create and activate virtual env
virtualenv env
source env/bin/activate

# create SSH key pair of 4096 bits to use it for instances at Rackspace
ssh-keygen -f ${WORKSPACE}/key -t rsa -b 4096

# Install pyrax dependency
pip install pyrax
/opt/qa/distributed-tests/rackspace-server-manager.py create -n ${MACHINES_COUNT}

for retry in `seq 1 $MAX_ATTEMPTS`
do
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i hosts --private-key=key /opt/qa/distributed-tests/distributed-server.yml -u root
  ret=$?
  if [ $ret -eq 0 ]; then
    break
  fi
  echo 'Attempting to run again...'
done