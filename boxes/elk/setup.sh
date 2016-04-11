#!/bin/bash

echo "Provisioning virtual machine..."
echo "Installing pip"

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

echo "starting kibana xoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxoxo"
nohup sudo /opt/kibana/bin/kibana > kibana.log 2>&1 &

# Installation of Logstash
echo "Installing Logstash"
wget https://download.elastic.co/logstash/logstash/packages/debian/logstash_2.2.2-1_all.deb
sudo dpkg -i logstash_2.2.2-1_all.deb
sudo service logstash start 

# Install Firefox
# sudo apt-get install -y firefox
