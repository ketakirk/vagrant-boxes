#!/bin/bash

echo "Provisioning virtual machine..."

# Update apt-get
sudo apt-get update
sudo apt-get upgrade

# Install Java
echo "Installing Java"
sudo apt-get install -y default-jre-headless

# Installation of Elasticsearch
echo "Installing Elasticsearch"
wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/2.2.1/elasticsearch-2.2.1.deb
sudo dpkg -i elasticsearch-2.2.1.deb
sudo update-rc.d elasticsearch defaults 95 10
sudo /etc/init.d/elasticsearch restart

# Installing HQ plugin
cd /usr/share/elasticsearch/bin
sudo ./plugin install royrusso/elasticsearch-HQ

# Installation of Kibana
echo "Installing Kibana"
wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb http://packages.elastic.co/kibana/4.4/debian stable main" | sudo tee -a /etc/apt/sources.list
sudo apt-get update && sudo apt-get install kibana
sudo update-rc.d kibana defaults 95 10

echo "starting kibana"
nohup sudo /opt/kibana/bin/kibana > kibana.log 2>&1 &

# Installation of Logstash
echo "Installing Logstash"
wget https://download.elastic.co/logstash/logstash/packages/debian/logstash_2.2.2-1_all.deb
sudo dpkg -i logstash_2.2.2-1_all.deb
sudo service logstash start 

# Install Firefox
# sudo apt-get install -y firefox

# Install git
echo "Installing git"
sudo apt-get install -y git

# Clone the elk_test repository in vagrant's home dir and
# run the python script to generate fake log data
echo "Generating test log data"
cd /home/vagrant
git clone https://github.com/rohan-kekatpure/elk_test.git
cd /home/vagrant/elk_test
python generate_log_data.py

# Load generated data into Logstash
echo "Loading data to logstash"
export LOGSTASH_HOME='/opt/logstash'
$LOGSTASH_HOME/bin/logstash -f '/home/vagrant/elk_test/logstash-test.conf' &

# Change ownership of '/home/vagrant' folder
sudo chown -R vagrant /home/vagrant

# Index the loaded data using ElasticSearch
echo "Indexing data using ElasticSearch"
# to be completed

# Plot the data using Kibana
echo "Creating Kibana plots"
# to be completed



