install.packages("shiny")
library(shiny)
library(ggplot2)
library(tidyverse)
library(jsonlite)

graf <- fluidPage(
  titlePanel("Veiklos kodas 560000"),
  sidebarLayout(
    sidebarPanel(
      selectizeInput("kodas",
                     "Pasirinkite",
                     choices = NULL)),
    
    
    mainPanel(
      tableOutput("table"),
      plotOutput("plot")
    )
  )
)

ser <- function(input, output, session) {
  data <- readRDS("../data/DUOMENYS.rds")
  updateSelectizeInput(session, "kodas", choices = data$name, server = TRUE)
  output$plot <- renderPlot(
    data %>%
      filter(name == input$kodas) %>%
      ggplot(aes(x = ym(month), y = avgWage)) +
      geom_point() + 
      geom_line() +
      theme_classic() +
      labs(x = "Mėnesiai", y = "Vidutinis atlyginimas")
  )
}

shinyApp(ui = graf, server = ser)
