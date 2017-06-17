#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
data <- read.csv("data.csv")
debtData <- data[, c("comunidad", "year", "deudaslargoplazo", "deudascortoplazo")]
debtData <- debtData[complete.cases(debtData),]
statesData <- as.vector(unique(data[,c("comunidad")]))
# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    titlePanel("Debt history 1996-2011 in spanish regions"),
    
    p(paste("This website is built to show reports of debt quantities for the 17 administrative regions in Spain. As the user, ", 
            "you will have two options: select the region you want to show the debt values for and select the year you want to show total",
            " debt values for.")),
    p(paste("For the first option you will get a lines graph showing the short term, long term and total debt values for all the regions",
            " given the year selected in the slide bar. You will also have the option to show these values for the whole nation by selecting the last ",
            "value, named 'ESPANA'.")),
    p(paste("For the second option you will get a horizontal bars graph showing the total debt for all the regions given the year selected",
            " in the slide bar.")),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            selectInput("state", "State:", statesData)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("thePlot")
        )
    ),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("year", "Select the year", min = 1996, max = 2011, value = 2011)
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("totalPlot")
        )
    )
))
