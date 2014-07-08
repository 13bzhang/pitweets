pitweets
========

**Raspberry Pi Twitter Collection Server**

Directions for how to set up your Raspberry Pi to collect a random sample of streaming tweets and store them as JSON files. We assume that you have already set up your Raspberry Pi with Raspbian as your OS. 

(1) Use SSH to gain remote access to your Raspberry Pi.

Use the instructions here: http://www.raspberrypi.org/documentation/remote-access/ssh/

(2) Set up FTP on your Raspberry Pi using `vsftp`. You can do this remotely using SSH or directly on your Raspberry Pi.

Use the instructions here: http://www.instructables.com/id/Raspberry-Pi-Web-Server/step9/Install-an-FTP-server/

(3) Download a FTP client. I recommend Cyberduck but you can use any of the following or your favorite.

* Cyberbuck: http://cyberduck.io/
* FileZilla: https://filezilla-project.org/
* Fugu: http://en.wikipedia.org/wiki/Fugu_(software)

(3) Install R on you Raspberry Pi.

(3a) Update all files from the default state.

    sudo apt-get update
    sudo apt-get upgrade

(3b) Install R along with packages that need to be manually installed.

    sudo apt-get install r-base

(3c) Install RCurl, rJava, and XML

    sudo aptitude install libcurl4-openssl-dev #RCurl
    sudo apt-get install r-cran-rjava #rJava
    sudo apt-get install libxml2-dev #XML

(4) Open up R from the Command Line and install the necessary packages. Follow the directions R provides about choosing a CRAN respository. 

    install.packages(c("rjson","RJSONIO","ROAuth","streamR","mailR"))



    
