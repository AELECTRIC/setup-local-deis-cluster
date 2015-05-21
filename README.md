Set up local Deis platform
============================

*Install Vagrant v1.6.5+*

https://www.vagrantup.com/

*Install VirtualBox*

https://www.virtualbox.org/wiki/Downloads

*Run install script*

    cd ./setup/
    ./setup.sh

*Note:*
At the end of the script (after about 15 - 30 minutes), it will prompt you to create an account with the local Deis cluster. Please enter a username, password, and email address when prompted.


Setup and deploy test application to Deis cluster
=================================================

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

