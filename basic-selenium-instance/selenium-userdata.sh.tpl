#!/bin/bash
apt-get update -y
apt-get install python3-pip python3-venv tor xvfb firefox -y

su - ubuntu
FILEPATH=/home/ubuntu/repos/selenium-tor-demo
mkdir -p $FILEPATH
wget -O $FILEPATH/geckodriver-archive.tar.gz ${gecko_dl_url}
tar -xvf $FILEPATH/geckodriver-archive.tar.gz
rm $FILEPATH/geckodriver-archive.tar.gz

Xvfb :99 -ac &
export DISPLAY=:99

wget -O $FILEPATH/torbundle-archive.tar.xz ${tor_dl_url}
tar -xvf torbundle-archive.tar.xz
rm torbundle-archive.tar.xz