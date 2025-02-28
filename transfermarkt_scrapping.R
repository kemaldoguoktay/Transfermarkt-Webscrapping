library(dplyr)
library(tidyverse)
library(rvest)
library(openxlsx)
library(purrr)

Sys.setlocale("LC_CTYPE", "en_US.UTF-8")

# Write here your path

comp <- read.csv("C:\\Users\\Lenovo\\Desktop\\VSC\\R\\comp_25.csv")

comp$league_id <- c(1:25)
comp <- comp %>% relocate(league_id, .before = "Area")

head(comp)

standing_table <- function(n){
  url <- comp$Standings_URL[n]
  
  tables <- read_html(url, encoding = "UTF-8") %>%
    html_nodes("table") %>%
    html_table()
  
  df <- tables[[2]]
  df <- as.data.frame(df)
  df <- df[-2]
  names(df)[1] <- "Position"
  names(df)[3] <- "Played"
  names(df)[8] <- "GD"
  
  df <- as.data.frame(df)
  
  df$league_id <- rep(n)
  
  df <- df %>% relocate(league_id, .before = Position)
  
  return(df)
}

standing_table(1)

data <- data.frame()
data

for (i in 1:25){
  s <- standing_table(i)
  data <- rbind(data,s)
}

head(data)
head(s)

merge_df <- merge(data,comp, by="league_id")
head(merge_df)

merge_df <- merge_df[-c(16,17)]
head(merge_df)

merge_df$Year <- rep(2024)

# write.csv(merge_df, file = "standings.csv", fileEncoding = "UTF-8", row.names = FALSE)

# Now the part of finding n years data

final_result <- data.frame()

for (i in 2024:2021) {
  
  comp$Standings_URL <- gsub('2024', i, comp$Standings_URL)
  comp$Comp_URL <- gsub('2024', i, comp$Comp_URL)
  
  data_range <- data.frame()
  for (a in 1:25) {
    s <- standing_table(a)
    data_range <- rbind(data_range, s)
  }
  
  merge_range <- merge(data_range, comp, by = "league_id")
  merge_range <- merge_range[-c(16, 17)]
  merge_range$Year <- rep(i)
  
  final_result <- rbind(final_result, merge_range)
  
  comp$Standings_URL <- gsub(i, "2024", comp$Standings_URL)
  comp$Comp_URL <- gsub(i, "2024", comp$Comp_URL)
}

final_result <- distinct(final_result)

head(final_result)
tail(final_result)

# write.csv(final_result, file = "standings_15_24.csv", fileEncoding = "UTF-8", row.names = FALSE)



