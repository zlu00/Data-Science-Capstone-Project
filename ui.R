#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Coursera Data Science Capstone Project"),
  
  fluidRow(
    column(2),
    column(8, tags$div(textInput("text", label = h3("Enter your input here:"), value = ,width = "300%"),
                      submitButton("Submit")),
                      tags$hr(),
                      h3("Prediction Model Selection and its Result:"),
                      tags$span(style="color:darkred", tags$strong(tags$h3(textOutput("predictedWord"))))
    ),
    column(2)
  )

))




