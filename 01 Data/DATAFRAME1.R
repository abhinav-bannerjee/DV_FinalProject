require("jsonlite")
require("RCurl")
require("dplyr")
# Change the USER and PASS below to be your UTEid
df1 <- data.frame(fromJSON(getURL(URLencode('skipper.cs.utexas.edu:5001/rest/native/?query="select * from TOPCOMPANY "'),httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_kc35827', PASS='orcl_kc35827', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE) ))
summary(df1)
df1<- df1%>%arrange(RANK)
head(df1,20)
