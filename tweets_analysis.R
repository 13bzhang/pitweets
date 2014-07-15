# WORLD CUP: Small sample analysis
# remove everything from list
rm(list=ls(all=T))
# load file directory
cd <- "~/Dropbox/WorldCup/data"
setwd(cd)
# required libraries
# install.packages("ggplot2","ggmap","maps","countrycode","taRifx","translate")

# libraries
library(ggplot2)
library("ggmap", lib.loc="/Library/Frameworks/R.framework/Versions/3.1/Resources/library")
library(maps)
library(countrycode)
library(taRifx)
library(translate)

# function from Pablo 
format.twitter.date <- function(datestring, format="datetime"){
  if (format=="datetime"){
    date <- as.POSIXct(datestring, format="%a %b %d %H:%M:%S %z %Y")
  }
  if (format=="date"){
    date <- as.Date(datestring, format="%a %b %d %H:%M:%S %z %Y")
  }   
  return(date)
}

# import csv
fn <- "FILE NAME OF YOUR FILE"
w <- read.csv(fn,sep=",",header=T)
w <- w[w$language!="language",]
w$long <- destring(w$c1)
w$lat <- destring(w$c2)

# fix the language problem
iso_lang <- read.csv("~/Dropbox/WorldCup/data/iso_lang.txt", header=F)
names(iso_lang) <- c("iso3","blank","iso2","langu","langl")
iso_lang$iso2 <- as.character(iso_lang$iso2)
iso_lang$iso3 <- as.character(iso_lang$iso3)
w$language <- as.character(w$language)
w$fix <- is.element(w$language,c(iso_lang$iso2,iso_lang$iso3,"und","in",
                                 "iw", "ckb", "rs"))
d <- w[w$fix==T,] # create new dataset that doesn't have the language problem
d$language <- factor(d$language)
for (i in 4:13){
  d[,i] <- droplevels(d[,i])
}

# convert the time
d$t <- format.twitter.date(d$time)
# game time
start <- format.twitter.date("Thu Jun 24 00:13:00 +0000 2014")
end <- format.twitter.date("Thu Jun 24 00:21:00 +0000 2014")
d$subset <- ifelse(as.numeric(d$t)>as.numeric(start) & as.numeric(d$t)<as.numeric(end),1,0)

# translation into English 
k = "YOUR GOOGLE API KEY"
ok <- languages(target = "en", key = k)
# check to see which translations are ok
d$ok <- is.element(as.character(d$language),ok)
d$tweeten <- rep(NA, length(d$language)) # store translated
d$tweet <- as.character(d$text) 
d$l <- as.character(d$language)
# for loop
end <- 10
for (i in 1:end){
	if (d$ok[i]==T & d$l[i]!="en"){
		d$tweeten[i] <- translate(query=d$tweet[i],
			source=d$language[i],
			target="en",key=k)
	} else{
		d$tweeten[i] <- d$tweet[i]
	}


# Make some maps
#Using GGPLOT, plot the Base World Map
mp <- NULL
mapWorld <- borders("world", colour="black", fill="white") # create a layer of borders
mp <- ggplot() +   mapWorld
#Now Layer the cities on top
mp <- mp+ geom_point(data=w,aes(x=long, y=lat) ,color="blue", size=0.9) 
mp
}
