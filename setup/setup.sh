#!/usr/bin/env bash

#Main Deis platfom setup script (for Vagrant) - needs to be tested further
#Please pull requests with any fixes you may have
#See: README.md

SCRIPT_PWD=$(pwd)

type vagrant >/dev/null 2>&1 || { echo >&2 "Please install vagrant (see README)"; exit 1; }
type virtualbox >/dev/null 2>&1 || { echo >&2 "Please install virtualbox (see README)"; exit 1; }

if [ ! -d ~/.ssh ]
then
    echo "Please create a public / private key pair. See steps 1 - 3 here: https://help.github.com/articles/generating-ssh-keys/"
    exit 1
fi

VAGRANT_TRIGGERS=$(cat ~/.vagrant.d/plugins.json | grep "vagrant-triggers");
if [ -z "$VAGRANT_TRIGGERS" ]
then
	echo "Installing vagrant-triggers plugin ..."
	sudo vagrant plugin install vagrant-triggers
else 
	echo "vagrant-triggers plugin is installed"
fi

if [ ! -d ~/bin ]
then
	mkdir ~/bin
fi

#Install deisctl utility, if it's not already installed:
type deisctl >/dev/null 2>&1 || { 
	echo "Installing deisctl utility";
	cd ~/bin
	curl -sSL http://deis.io/deisctl/install.sh | sh -s 1.6.0
}

USER_BIN_DIR_EXISTS=$(echo $PATH | grep "/Users/`whoami`/bin")

if [ -z "$USER_BIN_DIR_EXISTS" ]
then
	echo "Adding /Users/`whoami`/bin to PATH"
	echo "export PATH=\"/Users/`whoami`/bin:\$PATH\"" >> ~/.profile
fi

if [ -z "$DEISCTL_TUNNEL" ]
then
	echo "Adding DEISCTL_TUNNEL to BASH profile"
	echo "export DEISCTL_TUNNEL=172.17.8.100" >> ~/.profile
fi


source ~/.profile

#Install deis utility, if it's not already installed
type deis >/dev/null 2>&1 || { 
	echo "Installing deis utility ..."
	cd ~/bin
	curl -sSL http://deis.io/deis-cli/install.sh | sh
}

echo "Cloning deis source code ..."

if [ ! -d ~/Sites/deis ]; 
then
	mkdir -p ~/Sites/deis
fi

cd ~/Sites/deis

#If ~/Sites/deis/deis does not exist, clone deis git repository
if [ ! -d ~/Sites/deis/deis ]
then
	git clone https://github.com/deis/deis.git
fi

cd deis
#TODO - set deis version (branch) via parameter
git checkout v1.6.0

echo "Generating new discovery URL ..."
cd ~/Sites/deis/deis
make discovery-url

echo "Booting CoreOS ..."
vagrant up

echo "Enabling SSH connections to created VMs ..."
ssh-add ~/.vagrant.d/insecure_private_key

echo "Setting deisctl config options ..."
deisctl config platform set sshPrivateKey=${HOME}/.vagrant.d/insecure_private_key
deisctl config platform set domain=local3.deisapp.com

echo "Installing and starting Deis platform"
deisctl install platform
deisctl start platform

echo "Creating deis administrator account - please enter the requested information:"
deis register http://deis.local3.deisapp.com

echo "Uploading SSH key to the Deis cluster (select the number for id_rsa.pub or id_dsa.pub):"
deis keys:add

echo "Adding wildcard SSL cerficate to cluster ..."
cd $SCRIPT_PWD
./add_wildcard_ssl_to_deis.sh

echo "All done! Please see README file for instructions on setting up and deploying your first Deis application"



