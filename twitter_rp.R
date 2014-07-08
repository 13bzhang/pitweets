#########################################
# Raspberry Pi Tweets Collection Server

# Set up your working directory!
# setwd("/var/www/twitter")

# install.packages(c("rjson",
#                    "RJSONIO",
#                    "ROAuth",
#                    "streamR",
#                    "mailR"))

############################
# Twitter API Set Up
# library(ROAuth)
# requestURL <- "https://api.twitter.com/oauth/request_token"
# accessURL <- "https://api.twitter.com/oauth/access_token"
# authURL <- "https://api.twitter.com/oauth/authorize"
# consumerKey <- "vnGm03KIVHKCUEqwG9K1heTnd"
# consumerSecret <- "1M5Inka8XifjGbkZYGsBTnHpsod4ba9DM0LVK03EW4MERVgd7F"
# my_oauth <- OAuthFactory$new(consumerKey = consumerKey, consumerSecret = consumerSecret, 
#                              requestURL = requestURL, accessURL = accessURL, authURL = authURL)
# my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
# save(my_oauth, file = "my_oauth.Rdata")

source("functions.R")
library(rJava)
library(rjson)
library(RJSONIO)
library(ROAuth)
library(streamR)
library(mailR)
load("my_oauth.Rdata")
source("TwitterCreek2.R")

# Fill in the necessary information
myemail <- "YOUR EMAIL ADDRESS"
toemail <- "RECIPENT EMAIL ADDRESS"
hostname <- "YOUR EMAIL HOST ADDRESS"
eport <- # Your email host port number
eusername <- "YOUR EMAIL ACCOUNT USER NAME"
epassword <- "YOUR EMAIL PASSWORD"
time <- # Number of seconds you want to collect per loop
proportion <- # proportion of tweets you want to collect (0.0005 is good)
start <- # Beginning of loop
end <- # End of loops 
  
# Twitter Collection 
  
for(i in start:end){
  tryCatch({
    d <- TwitterCreek2(paste(c("Run",i,".json"),collapse=""), timeout = time, oauth = my_oauth, verbose = TRUE,p=proportion)  
    # Print Alert Number
    print(paste("Alert ",i,sep=""))
    # Get the Daily Fortune 
    r <- sample(x=1:length(c),1)
    # email alerts
    send.mail(from = myemail,
              to = toemail,
              subject = paste("Raspberry Pi Twitter Alert",i,sep=" "),
              body = paste("Raspberry Pi Alert",i,d,sep=" "),
              smtp = list(host.name = hostname, port = eport, user.name = eusername, passwd = epassword, ssl = TRUE),
              authenticate = TRUE,
              send = TRUE)
  }, error=function(e){
    send.mail(from = myemail,
              to = toemail,
              subject = "ERROR ALLERT!",
              body = "Something went wrong with your Tweets collection!",
              smtp = list(host.name = hostname, port = eport, user.name = eusername, passwd = epassword, ssl = TRUE),
              authenticate = TRUE,
              send = TRUE)
  })
}


