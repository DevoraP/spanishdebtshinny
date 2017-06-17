#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library("reshape2")
library(ggplot2)
data <- read.csv("data.csv")
debtData <- data[, c("comunidad", "year", "deudaslargoplazo", "deudascortoplazo")]
debtData <- debtData[complete.cases(debtData),]
debtData$deudaslargoplazo <- debtData$deudaslargoplazo * 100
debtData$deudascortoplazo <- debtData$deudascortoplazo * 100
cummulatedDebtData <- debtData$deudaslargoplazo + debtData$deudascortoplazo
debtData$deudastotal <- cummulatedDebtData
statesData <- as.vector(unique(data[,c("comunidad")]))
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    chosenData <- reactive({
        chosenData <- debtData[debtData$comunidad==input$state,] 
    })
    output$thePlot <- renderPlot({
        ggplot(data=chosenData(), aes(x=year)) + 
            geom_line(aes(y = deudastotal, colour = "Total Debt")) + 
            geom_line(aes(y = deudaslargoplazo, colour = "Long Term Debt")) + 
            geom_line(aes(y = deudascortoplazo, colour = "Short Term Debt")) + 
            ylab(label="Debt in EUR") + 
            xlab("Year") + 
            ggtitle(paste("Debt plot for State ", input$state, sep=""))
    })
    output$totalPlot <- renderPlot({
        chosenData <- reactive({
            chosenData <- debtData[debtData$year==input$year & debtData$comunidad != "ESPANA",]
        })
        barplot(chosenData()$deudastotal, main=paste("Total Debt in EUR in Spain in", input$year), horiz=TRUE, names.arg=chosenData()$comunidad,las=1)
    })
})
