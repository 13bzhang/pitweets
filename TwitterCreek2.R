############################
# Written by A. Bertoli
# Additions by B. Zhang

TwitterCreek2=function(file.name, timeout = 0, tweets = NULL, p=0.01, oauth = NULL, 
                      verbose = TRUE) 
{
  if (!is.null(oauth)) {
    library(ROAuth)
  }
  open.in.memory <- FALSE
  if (is.null(oauth)) {
    stop("No authentication method was provided. \n        Please use an OAuth token.")
  }
  if (!is.null(oauth)) {
    if (!inherits(oauth, "OAuth")) {
      stop("oauth argument must be of class OAuth")
    }
    if (!oauth$handshakeComplete) {
      stop("Oauth needs to complete its handshake. See ?filterStream.")
    }
  }
  i <- 0
  if (verbose == TRUE) 
    message("Capturing tweets...")
  if (nchar(file.name) == 0) {
    open.in.memory <- TRUE
    file.name <- tempfile()
  }
  conn <- file(description = file.name, open = "a")
  
  write.tweets <- function(x) {
    p=p*100
    keep=sample(c(0,1),1,prob=c(1-p,p))
    if(keep==1){
      if (nchar(x) > 0) {
        i <<- i + 1
        writeLines(x, conn, sep = "")
      }
    }}
  if (!is.null(tweets) && is.numeric(tweets) && tweets > 0) {
    write.tweets <- function(x) {
      if (i >= tweets) {
        break
      }
      if (nchar(x) > 0) {
        i <<- i + 1
        writeLines(x, conn, sep = "")
      }
    }
  }
  init <- Sys.time()
  url <- "https://stream.twitter.com/1.1/statuses/sample.json"
  if (!is.null(oauth)) {
    output <- tryCatch(oauth$OAuthRequest(URL = url, params = list(), 
                                          method = "POST", customHeader = NULL, cainfo = system.file("CurlSSL", 
                                                                                                     "cacert.pem", package = "RCurl"), writefunction = write.tweets, 
                                          timeout = timeout), error = function(e) e)
  }
  close(conn)
  seconds <- round(as.numeric(difftime(Sys.time(), init, units = "secs")), 
                   0)
  if (open.in.memory == TRUE) {
    raw.tweets <- readLines(file.name, warn = FALSE, encoding = "UTF-8")
    if (verbose == TRUE) {
      m1 <- paste(seconds, "sec", length(raw.tweets), 
              "tweets", sep=" ")
      return(m1)
    }
    unlink(file.name)
    return(raw.tweets)
  }
  if (open.in.memory == FALSE) {
    if (verbose == TRUE) {
      m2 <- paste(seconds,"sec", i, "tweets",sep=" ")
      return(m2)
    }
  }
}
