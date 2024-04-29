
install.packages("plotly")
install.packages("gganimate")
install.packages("htmlwidgets")

library(tidyverse)
library(plotly)
library(gganimate)
library(htmlwidgets)

data1 <- readRDS("../data/DUOMENYS.rds")

# 2.1 Histograma:

# NA reikšmių šalinimas:
data2 <- data1[complete.cases(data1$avgWage), ]

graph <- ggplot(data = data2, aes(x = avgWage)) +
  geom_histogram() +
  labs(ylab = "Kiekis", x = "Vidutinis atlyginimas", main = "Vidutinio atlyginimo histograma")

ggsave("../img/uzd2.1.png", graph, width = 3000, height = 1500, units = ("px"))

# 2.2  5 įmonių vidutinio atlyginimo kitimo dinamiką metų eigoje:

top5 <- data2 %>%
  group_by(name) %>%
  summarise(vid = max(avgWage)) %>%
  arrange(desc(vid)) %>%
  head(5)

top5

p <- data2 %>%
  filter(name %in% top5$name) %>%
  mutate(month = ym(month)) %>%
  ggplot(aes(x = month, y = avgWage, color = name) ) +
  geom_line() +
  labs(x = "Mėnesis", y = "Vidurkis", color = "Kompanijos pavadinimas")

ggplotly(p)

ggsave("../img/uzd2.2.png", p, width = 3000, height = 1500, units = ("px"))

#2.3 Iš išrinktų 5 įmonių išrinkite maksimalų apdraustų darbuotojų skaičių. Atvaizduokite stulpeline diagrama mažėjimo tvarka:
library(dplyr)
library(ggplot2)

TopI <- data %>%
  filter(name %in% top5$name) %>%
  group_by(name) %>%
  summarise(Ins = max(numInsured)) %>%
  arrange(desc(Ins))

TopI$name = factor(TopI$name, levels = TopI$name[order(TopI$Ins, decreasing = TRUE)])

Grafikas <- TopI %>%
  ggplot(aes(x = name, y = Ins, fill = name)) + 
  geom_bar(stat = "identity", position = "dodge") + 
  theme_classic() +
  labs(title = "Maksimalus apdraustų darbuotojų skaičius 5 įmonėse", 
       x = "Įmonė", y  = "Apdrausti", 
       fill = "Kompanijos pavadinimas")

ggsave("../img/uzd2.3.png", Grafikas, width = 5000, height = 2500, units = ("px"))
ggplotly(Grafikas)