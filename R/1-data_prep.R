install.packages("tidyverse")
install.packages("rjson")
install.packages("jsonlite")

library(tidyverse)
library(rjson)
library(jsonlite)

cat("Dabartinė direktorija: ", getwd())

download.file("https://atvira.sodra.lt/imones/downloads/2023/monthly-2023.json.zip", "../data/temp")
unzip("../data/temp",  exdir = "../data/")

readLines("../data/monthly-2023.json", 20)
data <- fromJSON("../data/monthly-2023.json")


data %>%
  filter(ecoActCode == 560000) %>%
  saveRDS("../data/DUOMENYS.rds")
file.remove("../data/temp")
file.remove("../data/monthly-2023.json")
