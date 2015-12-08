setwd("/Users/CK/DV_Finalproject/01 Data")
file_path <- "2.csv"

df <- read.csv(file_path)


# Replace "." (i.e., period) with "_" in the column names.
names(df) <- gsub("\\.+", "_", names(df))

str(df) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.
measures <- c()
dimensions <- setdiff(names(df), measures)



write.csv(format(df, scientific = NA), paste(gsub(".csv", "", file_path), "..csv", sep="" ), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}

sql <- paste(sql, ");")
cat(sql)
