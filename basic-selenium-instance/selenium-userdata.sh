#!/bin/bash
# Basic userdata script for setting up my selenium-with-tor-demo project
# This DOES NOT STAND UP A VIRTUAL DESKTOP -- refer to these steps if you want one -> https://ubuntu.com/tutorials/ubuntu-desktop-aws#1-overview
apt-get update -y
apt-get install python3-pip python3-venv tor xvfb firefox -y
echo export DISPLAY=:99 >> /etc/profile

# Assume ubuntu user and create the working project directory. su command is sometimes finicky, hence why there's a chown at the end of this script
su - ubuntu
FILEPATH=/home/ubuntu/repos/selenium-tor-demo
mkdir -p $FILEPATH

cd $FILEPATH  # Using cd within userdata can sometimes be finicky-- use explicit FILEPATH var where possible
# Pull selenium-with-tor-demo repo to get requirements.txt and interactive_test.py files
git init $FILEPATH
git remote add origin https://github.com/Han-Lon/selenium-with-tor-demo.git
git fetch --all
git pull origin main

# Create Python virtual environment and install dependencies
python3 -m venv $FILEPATH/venv
source ./venv/bin/activate
pip install -r requirements.txt

# Download geckodriver from source and untar
wget -O $FILEPATH/geckodriver-archive.tar.gz ${gecko_dl_url}
tar -xvf $FILEPATH/geckodriver-archive.tar.gz --directory $FILEPATH
rm $FILEPATH/geckodriver-archive.tar.gz

# Start Xvfb process in background
Xvfb :99 -ac &

# Download Tor bundle from source and untar
wget -O $FILEPATH/torbundle-archive.tar.xz ${tor_dl_url}
tar -xvf $FILEPATH/torbundle-archive.tar.xz --directory $FILEPATH
rm $FILEPATH/torbundle-archive.tar.xz

# Set ownership from root to ubuntu user
chown -R ubuntu:ubuntu /home/ubuntu