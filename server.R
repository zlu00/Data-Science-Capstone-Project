#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tm)

unigram <- readRDS("unigram.RData")
bigram <- readRDS("bigram.RData")
trigram <- readRDS("trigram.RData")
quadgram <- readRDS("quadgram.RData")

## Predict model function
predict <- function(input) {
    ## Clean up the input
    inputClean <- removeNumbers(removePunctuation(stripWhitespace(tolower(input))))
    inputSplit <- strsplit(inputClean, " ")[[1]]
    
    ## If the input has equal or more than 3 words
    if (length(inputSplit)>= 3) {
        ## We use the last 3 words
        inputSplit <- tail(inputSplit,3)
        if (length(head(quadgram[quadgram$first == inputSplit[1] & quadgram$second == inputSplit[2] & quadgram$third == inputSplit[3], 6],1)) == 0){
            predict(paste(inputSplit[2], inputSplit[3], sep=" "))
        }
        else {
            print(paste("Next word is predicted using quadgram:", head(quadgram[quadgram$first == inputSplit[1] & quadgram$second == inputSplit[2] & quadgram$third == inputSplit[3], 6],1)))
        }
    }
    ## If the input has 2 words
    else if (length(inputSplit) == 2){
        if (length(head(trigram[trigram$first == inputSplit[1] & trigram$second == inputSplit[2], 5],1)) == 0) {
            predict(inputSplit[2])
        }
        else {
            print(paste("Next word is predicted using trigram:", head(trigram[trigram$first == inputSplit[1] & trigram$second == inputSplit[2], 5],1)))
        }
    }
    ## If the input has only 1 word
    else if (length(inputSplit) == 1){
        if (length(head(bigram[bigram$first == inputSplit[1], 4],1)) == 0) {
            print(paste("No match found. Next word is predicted using the most common word in unigram:", unigram$first[1]))
        }
        else {
            print(paste("Next word is predicted using bigram:", head(bigram[bigram$first == inputSplit[1], 4],1)))
        }
    }
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
    output$predictedWord <- renderPrint(predict(input$text))
    output$enteredWords <- renderText({ input$text }, quoted = FALSE)
  
})
