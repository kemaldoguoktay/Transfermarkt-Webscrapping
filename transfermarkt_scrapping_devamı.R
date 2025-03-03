library(dplyr)
library(tidyverse)
library(rvest)
library(openxlsx)
library(purrr)
library(fuzzyjoin)

left <- read.csv("C:\\Users\\Lenovo\\Desktop\\VSC\\R\\left_join.csv")
right <- read.csv("C:\\Users\\Lenovo\\Desktop\\VSC\\R\\right_join.csv")

unk_r <- right[c(2,9)]
unknown_r <- distinct(unk_r[is.na(unk_r$Club.x),])
unknown_r  

unk_l <- left[c(2,9)]
unknown_l <- distinct(unk_l[is.na(unk_l$Club.y),])
unknown_l

unk_r <- right
unknown_r <- distinct(unk_r[is.na(unk_r$Club.x),])
unknown_r  

unk_l <- left
unknown_l <- distinct(unk_l[is.na(unk_l$Club.y),])
unknown_l  

# Takım isimlerinin eşleşmesini içeren listeyi oluştur
team_replacements <- c(
  "Zelez. Pancevo" = "Zeleznicar Pancevo",
  "Puskás AFC" = "Puskás Akadémia FC",
  "Union SG" = "Union Saint-Gilloise",
  "OH Leuven" = "Oud-Heverlee Leuven",
  "Grasshoppers" = "Grasshopper Club Zurich",
  "RB Salzburg" = "Red Bull Salzburg",
  "Blau Weiss Linz" = "FC Blau-Weiss Linz",
  "A. Klagenfurt" = "SK Austria Klagenfurt",
  "Bohemians 1905" = "Bohemians Prague 1905",
  "C. Budejovice" = "SK Dynamo Ceske Budejovice",
  "P. Niepolomice" = "Puszcza Niepolomice",
  "Paris SG" = "Paris Saint-Germain",
  "Twente FC" = "Twente Enschede FC",
  "CS U Craiova" = "CS Universitatea Craiova",
  "U Cluj" = "FC Universitatea Cluj",
  "ACSM Poli Iasi" = "ACSM Politehnica Iasi",
  "Unirea Slobozia" = "AFC Unirea 04 Slobozia",
  "B. Leverkusen" = "Bayer 04 Leverkusen",
  "E. Frankfurt" = "Eintracht Frankfurt",
  "Bor. M'gladbach" = "Borussia Mönchengladbach",
  "Bor. Dortmund" = "Borussia Dortmund",
  "TSG Hoffenheim" = "TSG 1899 Hoffenheim",
  "Vit. Guimarães" = "Vitória Guimarães SC",
  "Avs FS" = "Avs Futebol",
  "Atlético Madrid" = "Atlético de Madrid",
  "PAOK Salonika" = "PAOK Thessaloniki",
  "Aris Saloniki" = "Aris Thessaloniki",
  "H. Beer Sheva" = "Hapoel Beer Sheva",
  "M. Tel Aviv" = "Maccabi Tel Aviv",
  "B. Jerusalem" = "Beitar Jerusalem",
  "M. Bnei Reineh" = "Maccabi Bnei Reineh",
  "H. Jerusalem" = "Hapoel Jerusalem",
  "M. Petah Tikva" = "Maccabi Petah Tikva",
  "C. Rizespor" = "Caykur Rizespor",
  "Lyngby BK" = "Lyngby Boldklub",
  "Vejle BK" = "Vejle Boldklub",
  "Nottm Forest" = "Nottingham Forest",
  "Man City" = "Manchester City",
  "Man Utd" = "Manchester United",
  "Wolves" = "Wolverhampton Wanderers",
  "HamKam" = "Hamarkameratene",
  "Apol. Limassol" = "Apollon Limassol",
  "Omon. Aradippou" = "Omonia Aradippou",
  "EN Paralimniou" = "Enosis Neon Paralimniou",
  "Nea Salamis" = "Nea Salamina Famagusta",
  "Omonia 29 Maiou" = "Omonia 29is Maiou",
  "RWDM" = "RWD Molenbeek",
  "H. Petah Tikva" = "Hapoel Petah Tikva",
  "Odense BK" = "Odense Boldklub",
  "Sheff Utd" = "Sheffield United",
  "Paços Ferreira" = "FC Paços de Ferreira",
  "Hrv Dragovoljac" = "NK Hrvatski Dragovoljac",
  "G. Bordeaux" = "FC Girondins Bordeaux",
  "Arm. Bielefeld" = "Arminia Bielefeld",
  "H. Nof HaGalil" = "Hapoel Nof HaGalil",
  "Y. Malatyaspor" = "Yeni Malatyaspor",
  "Waasland-Beveren" = "KVRS Waasland - SK Beveren",
  "SFC Opava" = "Slezsky FC Opava",
  "H. Kfar Saba" = "Hapoel Kfar Saba",
  "BB Erzurumspor" = "Büyüksehir Belediye Erzurumspor",
  "F. Düsseldorf" = "Fortuna Düsseldorf",
  "D. Calarasi" = "Dunarea Calarasi",
  "Dep. La Coruña" = "Deportivo de La Coruña",
  "H. Ashkelon" = "Hapoel Ashkelon",
  "ASA Tg. Mures" = "AS Ardealul Tg. Mures (- 2018)",
  "J-Södra IF" = "Jönköpings Södra IF",
  "Inverness CT" = "Inverness Caledonian Thistle FC",
  "Anagen.Derynias" = "Anagennisi Derynias",
  "G. Ajaccio" = "GFC Ajaccio",
  "Mersin IY" = "Mersin Idmanyurdu",
  "K. Erciyesspor" = "Kayseri Erciyesspor",
  "QPR" = "Queens Park Rangers",
  "E. Braunschweig" = "Eintracht Braunschweig",
  "Pol. Warsaw" = "Polonia Warsaw",
  "H. Ramat Gan" = "Hapoel Ramat Gan",
  "Kardemir Karabük" = "Kardemir DC Karabükspor",
  "Istanbul BBSK" = "Istanbul Büyüksehir Belediyespor",
  "Espanyol" = "RCD Espanyol",
  "RCD Espanyol Barcelona" = "RCD Espanyol",
  "Mladost GAT" = "FK Mladost GAT Novi Sad",
  "Metalist" = "Metalist 1925 Kharkiv",
  "Rad" = "FK Radnik Surdulica",
  "Radnicki Nis" = "FK Radnicki Nis",
  "Backa" = "FK TSC Backa Topola",
  "Stal D." = "Stal Dniprodzerzhynsk",
  "Radnicki 1923" = "FK Radnicki 1923 Kragujevac",
  "Universitatea Cluj" = "FC Universitatea Cluj"
)

# Takım isimlerinin eşleşmesini içeren listeyi oluştur
teams <- c(
  "Espanyol" = "RCD Espanyol",
  "RCD Espanyol Barcelona" = "RCD Espanyol",
  "Mladost GAT" = "FK Mladost GAT Novi Sad",
  "Metalist" = "Metalist 1925 Kharkiv",
  "Rad" = "FK Radnik Surdulica",
  "Radnicki Nis" = "FK Radnicki Nis",
  "Backa" = "FK TSC Backa Topola",
  "Stal D." = "Stal Dniprodzerzhynsk",
  "Radnicki 1923" = "FK Radnicki 1923 Kragujevac",
  "Universitatea Cluj" = "FC Universitatea Cluj"
)

# Club.y sütunundaki değerleri eşleştirme ve değiştirme işlemi
left <- left %>%
  mutate(Club.y = ifelse(!is.na(Club.y) & Club.y %in% names(team_replacements), 
                         team_replacements[Club.y], Club.y))

left <- left %>%
  mutate(Club.x = ifelse(!is.na(Club.x) & Club.x %in% names(teams), 
                         teams[Club.x], Club.x))

right <- right %>%
  mutate(Club.y = ifelse(!is.na(Club.y) & Club.y %in% names(team_replacements), 
                         team_replacements[Club.y], Club.y))

head(right) # dolu olan Club.y

head(left) # dolu olan Club.x

right <- right[-2]

left <- left[-9]

names(left)[2] <- "Club"

names(right)[8] <- "Club"

right <- right[-c(3,4,5,6)]

left <- left[-c(8,9,10,11,12,13,14,15)]

right <- right[-c(11,12,13,14,15)] # Area Country Id Competition Tier çıkardım

right <- left %>%
  regex_right_join(right, 
                   by = c("league_id" = "league_id",
                          "Year" = "Year",
                          "Club" = "Club"))


# merged <- merge(left, right, by = c("league_id","Area", "Country", "Id", "Competition", "Tier", "Year", "Club"))

# merged <- merge(left, right, by = "Club")

# head(merged)

right <- right[-c(13,14)]

names(right)[c(1)] <- "League_id"

head(right)

right <- distinct(right)

right[duplicated(right[c("Club.x", "League_id", "Year.y")]), ]

arrange(right[duplicated(right[c( "Club.y", "League_id", "Year.y")]), ], desc(Year.y),League_id, Position)

right_unique <- right[!duplicated(right[c("Club.x", "League_id", "Year.y")]), ]

right_unique

arrange(right_unique[duplicated(right_unique[c( "Club.y", "League_id", "Year.y")]), ], desc(Year.y),League_id, Position)

right_cleaned <- right_unique %>%
  filter(!is.na(Year.y) & !is.na(Club.x)) 

# write.xlsx(right_cleaned, file = "end_full_12_25.xlsx", fileEncoding = "UTF-8", rowNames = FALSE)

options(max.print = 4000)




