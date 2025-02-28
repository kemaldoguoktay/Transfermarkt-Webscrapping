library(dplyr)
library(tidyverse)
library(rvest)
library(openxlsx)
library(purrr)

Sys.setlocale("LC_CTYPE", "en_US.UTF-8")

comp <- read.csv("C:\\Users\\Lenovo\\Desktop\\VSC\\Python\\Processing_Cont_Codes\\comp_25.csv")

comp$league_id <- c(1:25)
comp <- comp %>% relocate(league_id, .before = Area)

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

merge_df <- merge(data,comp, by="league_id")
head(merge_df)

merge_df <- merge_df[-c(16,17)]
head(merge_df)

merge_df

# write.csv(merge_df, file = "standings.csv", fileEncoding = "UTF-8", row.names = FALSE)

