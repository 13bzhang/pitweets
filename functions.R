getTimeline <- function(filename, n=3200, oauth_folder="~/credentials", screen_name=NULL, 
    id=NULL, since_id=-1, trim_user="false"){

    require(rjson); require(ROAuth)

    ## create list of credentials
    creds <- list.files(oauth_folder, full.names=T)
    ## open a random credential
    cr <- sample(creds, 1)
    cat(cr, "\n")
    load(cr)
    ## while rate limit is 0, open a new one
    limit <- getLimitTimeline(my_oauth)
    cat(limit, " hits left\n")
    while (limit==0){
        cr <- sample(creds, 1)
        cat(cr, "\n")
        load(cr)
        Sys.sleep(1)
        # sleep for 5 minutes if limit rate is less than 100
        rate.limit <- getLimitRate(my_oauth)
        if (rate.limit<100){
            Sys.sleep(300)
        }
        limit <- getLimitTimeline(my_oauth)
        cat(limit, " hits left\n")
    }
    ## url to call
    url <- "https://api.twitter.com/1.1/statuses/user_timeline.json"

    ## first API call
    if (!is.null(screen_name)){
        params <- list(screen_name = screen_name, count=200, trim_user=trim_user)
    }
    if (!is.null(id)){
        params <- list(id=id, count=200, trim_user=trim_user)   
    }
    
    url.data <- my_oauth$OAuthRequest(URL=url, params=params, method="GET", 
    cainfo=system.file("CurlSSL", "cacert.pem", package = "RCurl")) 
    Sys.sleep(.5)
    ## one API call less
    limit <- limit - 1
    ## changing oauth token if we hit the limit
    cat(limit, " hits left\n")
    while (limit==0){
        cr <- sample(creds, 1)
        cat(cr, "\n")
        load(cr)
        Sys.sleep(1)
        # sleep for 5 minutes if limit rate is less than 100
        rate.limit <- getLimitRate(my_oauth)
        if (rate.limit<100){
            Sys.sleep(300)
        }
        limit <- getLimitTimeline(my_oauth)
        cat(limit, " hits left\n")
    }
    ## trying to parse JSON data
    #json.data <- fromJSON(url.data, unexpected.escape = "skip")
    json.data <- RJSONIO::fromJSON(url.data)
    if (length(json.data$error)!=0){
        cat(url.data)
        stop("error! Last cursor: ", cursor)
    }
    ## writing to disk
    conn <- file(filename, "a")
    invisible(lapply(json.data, function(x) writeLines(rjson::toJSON(x), con=conn)))
    close(conn)
    ## max_id
    tweets <- length(json.data)
    max_id <- json.data[[tweets]]$id_str
    cat(tweets, "tweets. Max id: ", max_id, "\n")
    max_id_old <- "none"

    while (tweets < n & max_id != max_id_old & 
        as.numeric(max_id) > as.numeric(since_id)){
        max_id_old <- max_id
        if (!is.null(screen_name)){
            params <- list(screen_name = screen_name, count=200, max_id=max_id,
                trim_user=trim_user)
        }
        if (!is.null(id)){
            params <- list(id=id, count=200, max_id=max_id, trim_user=trim_user)
        }
        url.data <- my_oauth$OAuthRequest(URL=url, params=params, method="GET", 
        cainfo=system.file("CurlSSL", "cacert.pem", package = "RCurl")) 
        Sys.sleep(1)
        ## one API call less
        limit <- limit - 1
        ## changing oauth token if we hit the limit
        cat(limit, " hits left\n")
        while (limit==0){
            cr <- sample(creds, 1)
            cat(cr, "\n")
            load(cr)
            Sys.sleep(1)
            # sleep for 5 minutes if limit rate is less than 100
            rate.limit <- getLimitRate(my_oauth)
            if (rate.limit<100){
                Sys.sleep(300)
            }
            limit <- getLimitTimeline(my_oauth)
            cat(limit, " hits left\n")
        }
        ## trying to parse JSON data
        #json.data <- fromJSON(url.data, unexpected.escape = "skip")
        json.data <- RJSONIO::fromJSON(url.data)
        if (length(json.data$error)!=0){
            cat(url.data)
            stop("error! Last cursor: ", cursor)
        }
        ## writing to disk
        conn <- file(filename, "a")
        invisible(lapply(json.data, function(x) writeLines(toJSON(x), con=conn)))
        close(conn)
        ## max_id
        tweets <- tweets + length(json.data)
        max_id <- json.data[[length(json.data)]]$id_str
        cat(tweets, "tweets. Max id: ", max_id, "\n")
    }
}

getLimitRate <- function(my_oauth){
    require(rjson); require(ROAuth)
    url <- "https://api.twitter.com/1.1/application/rate_limit_status.json"
    params <- list(resources = "followers,application")
    response <- my_oauth$OAuthRequest(URL=url, params=params, method="GET", 
        cainfo=system.file("CurlSSL", "cacert.pem", package = "RCurl"))
    return(unlist(fromJSON(response)$resources$application$`/application/rate_limit_status`[['remaining']]))
}


getLimitTimeline <- function(my_oauth){
    require(rjson); require(ROAuth)
    url <- "https://api.twitter.com/1.1/application/rate_limit_status.json"
    params <- list(resources = "statuses,application")
    response <- my_oauth$OAuthRequest(URL=url, params=params, method="GET", 
        cainfo=system.file("CurlSSL", "cacert.pem", package = "RCurl"))
    return(unlist(fromJSON(response)$resources$statuses$`/statuses/user_timeline`[['remaining']]))

}
