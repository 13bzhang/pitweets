pitweets
========

### Raspberry Pi Tweets Collection Server

Directions for how to set up your Raspberry Pi to collect a random sample of streaming tweets and store them as JSON files. We assume that you have already set up your Raspberry Pi with Raspbian as your OS. 

### Part A: Install the Necessary Software

(1) Use SSH to gain remote access to your Raspberry Pi.

Use the instructions here: http://www.raspberrypi.org/documentation/remote-access/ssh/

(2) Set up FTP on your Raspberry Pi using `vsftp`. You can do this remotely using SSH or directly on your Raspberry Pi.

Use the instructions here: http://www.instructables.com/id/Raspberry-Pi-Web-Server/step9/Install-an-FTP-server/

(3) Download a FTP client. I recommend Cyberduck but you can use any of the following or your favorite.

* Cyberbuck: http://cyberduck.io/
* FileZilla: https://filezilla-project.org/
* Fugu: http://en.wikipedia.org/wiki/Fugu_(software)

(4) Test if you can access your Raspberry Pi via the FTP client you downloaded. Your server will be your IP address and your password will be your Raspberry Pi log-in password (the non-root one).

(5) Install R on you Raspberry Pi. If you have never used R before, here is some basic information: http://www.r-project.org/about.html

(5a) Update all files from the default state.

    sudo apt-get update
    sudo apt-get upgrade

(5b) Install R along with packages that need to be manually installed.

    sudo apt-get install r-base

(5c) Install RCurl, rJava, and XML

    sudo aptitude install libcurl4-openssl-dev #RCurl
    sudo apt-get install r-cran-rjava #rJava
    sudo apt-get install libxml2-dev #XML

(6) Open up R from the Command Line and install the necessary packages. Follow the directions R provides about choosing a CRAN respository. 

    install.packages(c("rjson","RJSONIO","ROAuth","streamR","mailR"))

### Part B: Setting up your Twitter API credentials

(7) Go to Twitter Developers and set up an developer account to get your API access keys

Use the instructions here: http://www.prophoto.com/support/twitter-api-credentials/

(8) Back in R, create an OAuth file using the following code. You will need your Twitter API consumer key and secret consumer key.

    library(ROAuth)
    library(streamR)
    library(RJSONIO)
    requestURL <- "https://api.twitter.com/oauth/request_token"
    accessURL <- "https://api.twitter.com/oauth/access_token"
    authURL <- "https://api.twitter.com/oauth/authorize"
    consumerKey <- "INSERT YOUR CONSUMER KEY"
    consumerSecret <- "INSERT YOUR SECRET CONSUMER KEY"
    my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
                             requestURL = requestURL, accessURL = accessURL, authURL = authURL)
    my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
    save(my_oauth, file = "my_oauth.Rdata")

### Part C: Running your R code

(9) Download the file "twitter_rp.R" and fill in the necessary information, such as working directory, email account, etc.

(10) Save your "twitter_rp.R" and send it to your Raspberry Pi via your FTP client. Also send the supporting files to your Raspberry Pi via your FTP client. Put them all in the same folder. Make sure your "my_oauth.Rdata" file is in that folder too. 

(11) You can test your R code by pasting it into R. After you're ready to run the R code, quit R. Using the command line, navigate to the folder where you saved your R code and run:

    nohup R CMD BATCH twitter_rp.R &
    exit

Check to see if a "Run1.JSON" file appeared in your folder and if it is growing in size. If yes, then your tweets collection is successful. You can exit out of SSH. 

(12) To stop the tweets collection, type in the command line:

    killall R


-- Written by Baobao Zhang (contributions from Andrew Bertoli)
