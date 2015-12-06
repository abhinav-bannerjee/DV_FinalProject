setwd("/Users/CK/DataVisualization/DV_Finalproject/01 Data")

file_path <- "1.csv"

df <- read.csv(file_path)


# Replace "." (i.e., period) with "_" in the column names.
names(df) <- gsub("\\.+", "_", names(df))

#str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.
names(df)[7] <- "Sales"
names(df)[8] <-"Profits"
  names(df)[9] <-"Assets"
  names(df)[10] <-"Market_Value"
measures <- c("Rank","Year","Sales","Profits","Assets","Market_Value")

dimensions <- setdiff(names(df), measures)


if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    df[d] <- data.frame(lapply(df[d], gsub, pattern=":",replacement= ";"))
  }
}


library(lubridate)


write.csv(format(df, scientific = NA), paste(gsub(".csv", "", file_path), "..csv", sep="" ), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
