#-------------------------------------------------------------------
# Downloading Instagram pictures for a certain hashtag or a location
# Benedikt Koehler, 2013
#-------------------------------------------------------------------

library(RCurl)
library(rjson)

# Login credentials
api.key <- "" # API key for Instagram API goes here

# Search data: either hashtag or location (bbox = Bounding Box)
hashtag <- ""
bbox <- "5.866240,47.270210,15.042050,55.058140"

# Time frame
maxdate <- "2013-07-31"
mindate <- "2013-07-01"
savedir <- substr(mindate, 6, 10)
workdir <- "C:/flickr_images/"

# Search parameters
sort <- "interestingness-desc" # Sort by Interestingness (or: relevance)
n <- 500
p <- 10

# Downloading the images
for (i in 1:p) {
    if (hashtag != "") {
        api <- paste("http://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&api_key=", api.key, "&nojsoncallback=1&page=", i, "&per_page=", n, "&tags=", hashtag, sep="")
        imgdir <- paste(workdir, hashtag, sep="")
        dir.create(imgdir)
    } else {
        api <- paste("http://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&api_key=", api.key, "&nojsoncallback=1&page=", i, "&per_page=", n, "&bbox=", bbox, "&min_taken_date=", mindate, "&max_taken_date=", maxdate, "&sort=", sort, sep="")
        imgdir <- paste(workdir, savedir, sep="")
        dir.create(imgdir)
    }

    raw_data <- getURL(api, ssl.verifypeer = FALSE)
    data <- fromJSON(raw_data, unexpected.escape="skip", method="R")

    for (u in 1:length(data$photos$photo)) {
        id <- data$photos$photo[[u]]$id
        farm <- data$photos$photo[[u]]$farm
        server <- data$photos$photo[[u]]$server
        secret <- data$photos$photo[[u]]$secret
        url <- paste("http://farm", farm, ".staticflickr.com/", server, "/", id, "_", secret, "_t.jpg", sep="")
        temp <- paste(imgdir, "/", id, ".jpg", sep="")
        download.file(url, temp, mode="wb")
    }
}
