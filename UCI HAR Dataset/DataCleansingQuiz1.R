library(xlsx)
library(XML)
library(data.table)
## Data Cleansing Week 1 Quiz code notes
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv "
destFile <- "DataCleansingQuiz1HouseValueData.csv"
download.file(fileUrl, destfile = destFile, method="curl")
data <- read.csv(destFile, sep=",")
ValueOver1Million <- subset(data, VAL==24)
##
#### Second data file
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
destFile <- " NaturalGasAquisitionProgram.xlsx"
download.file(fileUrl, destfile = destFile, method="curl")
dat <- read.xlsx(destFile, sheetIndex=1, rowIndex=c(18:23), colIndex = c(7:15))
sum(dat$Zip*dat$Ext,na.rm=T) 
#
### Third data file - XML
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
destFile <- "Restaurants.xml"
file.remove(destFile)
download.file(fileUrl, destfile = destFile, method="curl")

doc <- xmlRoot(xmlTreeParse(destFile, useInternalNodes = TRUE))
restaurants <- xmlToDataFrame(nodes = getNodeSet(doc, "//response/row/row"))
# Should tally to 127
nrow(subset(restaurants, zipcode == '21231'))

##
### Fourth quiz data file
##
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
destUrl <- "UScommunities.csv"
download.file(fileUrl, destfile = destFile, method="curl")
DT <- fread(destFile)
#DT <- subset(a, ,select = c("SEX","pwgtp15"))
ex1 <- function(x) {sapply(split(x$pwgtp15,x$SEX),mean)}
ex2 <- function(x) {mean(x[x$SEX==1,]$pwgtp15); mean(x[x$SEX==2,]$pwgtp15)}
ex3 <- function(x) {x[,mean(pwgtp15),by=SEX]}
ex4 <- function(x) {tapply(x$pwgtp15,x$SEX,mean)}
# Evaluate processing time
Rprof("ex1.out")
a1 <- replicate(n=1000, ex1(DT))
a2 <- replicate(n=1000, ex2(DT))
a3 <- replicate(n=1000, ex3(DT))
a4 <- replicate(n=1000, ex4(DT))
Rprof(NULL)
summaryRprof("ex1.out")
