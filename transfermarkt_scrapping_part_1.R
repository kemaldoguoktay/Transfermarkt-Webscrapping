library(dplyr)
library(tidyverse)
library(rvest)
library(openxlsx)
library(purrr)
library(fuzzyjoin)

Sys.setlocale("LC_CTYPE", "en_US.UTF-8")

# Write here your path

comp <- read.csv("C:\\Users\\Lenovo\\Desktop\\VSC\\R\\comp_25.csv")

comp$league_id <- c(1:25)
comp <- comp %>% relocate(league_id, .before = "Area")

head(comp)

# Left Join fonksiyonu

standing_table_left <- function(n){
  url <- comp$Standings_URL[n]
  
  tables <- read_html(url, encoding = "UTF-8") %>%
    html_nodes("table") %>%
    html_table()
  
  df_left <- tables[[2]]
  df_left <- as.data.frame(df_left)
  df_left <- df_left[-2]
  names(df_left)[1] <- "Position"
  names(df_left)[3] <- "Played"
  names(df_left)[8] <- "GD"
  
  df_left <- as.data.frame(df_left)
  
  urls <- comp$Comp_URL[n]
  
  table <- read_html(urls, encoding = "UTF-8") %>%
    html_nodes("table") %>%
    html_table()
  
  dfs <- table[[2]]
  dfs <- as.data.frame(dfs)
  dfs <- dfs[-1]
  dfs <- dfs[-7]
  dfs <- dfs[-1,]
  
  names(dfs) <- c("Club", "Squad", "Avg_Age", "Foreigners", "Avg_Market_Value", "Total_Market_Value")
  
  df_left <- dfs %>%
    regex_left_join(df_left, 
                    by = c("Club" = "Club"))
  
  df_left$league_id <- rep(n)
  
  df_left <- df_left %>% relocate(league_id, .before = Position)
  
  df_left$Position <- as.numeric(df_left$Position)
  df_left$league_id <- as.numeric(df_left$league_id)
  
  df_left <- arrange(df_left, league_id, Position)
  
  return(df_left)
}


# Right Join fonksiyonu

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
  
  urls <- comp$Comp_URL[n]
  
  table <- read_html(urls, encoding = "UTF-8") %>%
    html_nodes("table") %>%
    html_table()
  
  dfs <- table[[2]]
  dfs <- as.data.frame(dfs)
  dfs <- dfs[-1]
  dfs <- dfs[-7]
  dfs <- dfs[-1,]
  
  names(dfs) <- c("Club", "Squad", "Avg_Age", "Foreigners", "Avg_Market_Value", "Total_Market_Value")
  
  df <- dfs %>%
    regex_right_join(df, 
                     by = c("Club" = "Club"))
  
  df$Position <- as.numeric(df$Position)
  df$league_id <- as.numeric(df$league_id)
  
  df <- arrange(df, league_id, Position)
  
  return(df)
}

# Now the part of finding n years data

final_result <- data.frame()
final_result_left <- data.frame()


# Right Join yaparak

original_comp <- comp 

for (i in 2024:2012) {
  
  comp <- original_comp
  comp$Standings_URL <- gsub('2024', i, comp$Standings_URL)
  comp$Comp_URL <- gsub('2024', i, comp$Comp_URL)
  
  data_range <- data.frame()
  for (a in 1:25) {
    s <- standing_table(a)
    data_range <- rbind(data_range, s)
  }
  
  merge_range <- merge(data_range, comp, by = "league_id")
  merge_range$Year <- rep(i)
  
  final_result <- rbind(final_result, merge_range)
  
}

# Left Join yaparak 2024:2015

for (i in 2024:2012) {
  
  comp <- original_comp
  comp$Standings_URL <- gsub('2024', i, comp$Standings_URL)
  comp$Comp_URL <- gsub('2024', i, comp$Comp_URL)
  
  data_range <- data.frame()
  for (a in 1:25) {
    s <- standing_table_left(a)
    data_range <- rbind(data_range, s)
  }
  
  merge_range_left <- merge(data_range, comp, by = "league_id")
  merge_range_left$Year <- rep(i)
  
  final_result_left <- rbind(final_result_left, merge_range_left)
  
}


final_result <- arrange(final_result, desc(Year),league_id, Position)

final_result <- distinct(final_result[-c(22,23)])

final_result

final_result_left <- arrange(final_result_left, desc(Year),league_id, Position)

final_result_left <- distinct(final_result_left[-c(22,23)])

final_result_left

##

colSums(is.na(final_result))

colSums(is.na(final_result_left))

##

summary(final_result)
summary(final_result_left)

##

unk_r <- final_result[c(2,9)]
unknown_r <- distinct(unk_r[is.na(unk_r$Club.x),])
unknown_r  

unk_l <- final_result_left[c(2,9)]
unknown_l <- distinct(unk_l[is.na(unk_l$Club.y),])
unknown_l

write.csv(final_result, file = "right_join.csv", fileEncoding = "UTF-8", row.names = FALSE)
write.csv(final_result_left, file = "left_join.csv", fileEncoding = "UTF-8", row.names = FALSE)



