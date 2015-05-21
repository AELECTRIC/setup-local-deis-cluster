Overview
============================

This project contains a shell script which helps you quickly set up a local Deis cluster using Vagrant and VirtualBox. 

Deis is an open-source platform-as-a-service (PaaS) which lets you run Docker-based containers on a cluster of CoreOS machines.

For more information on Deis, please see: http://docs.deis.io/en/latest/

Fixes / additions are welcome via pull requests.

Pre-requisites
===========================

*Install Vagrant v1.6.5+*

https://www.vagrantup.com/

*Install VirtualBox*

https://www.virtualbox.org/wiki/Downloads

Installation
=========================

Run the install script as follows:

    cd ./setup/
    ./setup.sh

*Note:*
At the end of the script (after about 15 - 30 minutes), it will prompt you to create an account with the local Deis cluster. Please enter a username, password, and email address when prompted.


Deploy a test Docker application (container) to the Deis cluster
====================================================================

Clone the application from Github:

    cd ~/Sites/deis
    git clone https://github.com/deis/helloworld.git

Name the application:

    cd ~/Sites/deis/helloworld
    deis create hello-world

Push the application to the deis cluster
    
    git push deis master


Access test application
=========================================

*Regular HTTP:*

http://test-php.local3.deisapp.com/

*SSL*

Note: you will have to accept the self-signed certificate in your browser

https://test-php.local3.deisapp.com/

