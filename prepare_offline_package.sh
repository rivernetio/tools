#!/bin/bash

# export SITE=Toronto

branch=$1

git --version > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "You must install git and make sure to have connection to the internet"
  exit 1
fi

echo "Cloning ansible-ecp repository ..."

if [ "$branch" =  "" ]; then
  branch="master"
fi

if [ ! -d `pwd`/"ansible-ecp" ]; then
  echo "Branch $branch"
  git clone -b $branch https://github.com/rivernetio/ansible-ecp
    
  if [ $? -ne 0 ]; then
    echo "Failed to clone the ansible-ecp repository"
    exit 1
  fi
fi

cd ansible-ecp

echo "Prepare offline dependencies ..."
mkdir -p depends && cd depends
../scripts/prepare_offline_deps.sh

echo "Modify global variables ..."
cd ..
sed -i 's#src_image_tars_dir:.*#src_image_tars_dir: \"{{ playbook_dir }}/depends/image_tars\"#g' group_vars/all.yml
sed -i 's#src_rpms_dir:.*#src_rpms_dir: \"{{ playbook_dir }}/depends/rpm\"#g' group_vars/all.yml
sed -i 's#ecp_local_charts_repo:.*#ecp_local_charts_repo: \"{{ playbook_dir }}/depends/charts/repo\"#g' group_vars/all.yml

cd ..
tar -cvzf ansible-ecp.tar.gz ansible-ecp
