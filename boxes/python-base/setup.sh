#!/bin/bash

echo "Provisioning virtual machine..."

echo "Installing pip"

# Update apt-get
sudo apt-get update
sudo apt-get upgrade

# Install mysql stuff
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get remove --purge mysql-client-5.5 mysql-client-core-5.5 
sudo apt-get remove --purge mysql-common mysql-server mysql-server-5.5 mysql-server-core-5.5
sudo apt-get install mysql-server

sudo apt-get install debconf-utils -y > /dev/null
debconf-set-selections <<< "mysql-server mysql-server/root_password password 1234"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password 1234"
sudo apt-get install -y mysql-server

# Install pip
sudo apt-get install -y python-pip

# Install virtual environment
pip install virtualenv

# Create Virtual environment
virtualenv myapp

# Activate virtualenv
source myapp/bin/activate

# install stuff in virtualenv
pip install flask
pip install thrivext



