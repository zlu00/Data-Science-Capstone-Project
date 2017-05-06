library(tm)
library(rJava)
library(RWeka)

## Load data
setwd("~/Documents/Coursera - Data Science/Data Science Capstone")
blog <- readLines("./final/en_US/en_US.blogs.txt", skipNul=TRUE, encoding="UTF-8")
news <- readLines("./final/en_US/en_US.news.txt", skipNul=TRUE, encoding="UTF-8")
twit <- readLines("./final/en_US/en_US.twitter.txt", skipNul=TRUE, encoding="UTF-8")

## Sample data
set.seed(998)
blogTraining <- sample(blog, size=12000, replace=FALSE)
newsTraining <- sample(news, size=12000, replace=FALSE)
twitTraining <- sample(twit, size=12000, replace=FALSE)
rm(blog, news, twit)

## Create a merged corpus and clean up the data by removing punctuation and numbers
mergedTraining <- paste(blogTraining, newsTraining, twitTraining)
mergedCorpus <- VCorpus(VectorSource(mergedTraining))
mergedCorpus <- tm_map(mergedCorpus, tolower)
mergedCorpus <- tm_map(mergedCorpus, removeNumbers)
mergedCorpus <- tm_map(mergedCorpus, removePunctuation)
# mergedCorpus <- tm_map(mergedCorpus, removeWords, stopwords("english"))
mergedCorpus <- tm_map(mergedCorpus, stripWhitespace)
mergedCorpus <- tm_map(mergedCorpus, stemDocument)
rm(blogTraining, newsTraining, twitTraining)

## Define a function to make N-grams
Ngram <- function (n) {
    Tokenizer <- NGramTokenizer(mergedCorpus, Weka_control(min = n, max = n))
    NgramOutput <- data.frame(table(Tokenizer), stringsAsFactors = FALSE)
    NgramOutput <- NgramOutput[order(NgramOutput$Freq, decreasing = TRUE), ]
    NgramOutput
}

## Calculate N-Grams
unigram <- Ngram(1)
bigramBasic <- Ngram(2)
trigramBasic <- Ngram(3)
quadgramBasic <- Ngram(4)


## Split strings and save data frames into RData files
unigram$first <- unigram$Tokenizer
saveRDS(unigram,"./RData/unigram.RData")

bigramSplit <- strsplit(as.character(bigramBasic$Tokenizer),split=" ")
bigram <- transform(bigramBasic,first = sapply(bigramSplit,"[[",1),second = sapply(bigramSplit,"[[",2))
saveRDS(bigram,"./RData/bigram.RData")

trigramSplit <- strsplit(as.character(trigramBasic$Tokenizer),split=" ")
trigram <- transform(trigramBasic,first = sapply(trigramSplit,"[[",1),second = sapply(trigramSplit,"[[",2),third = sapply(trigramSplit,"[[",3))
saveRDS(trigram,"./RData/trigram.RData")

quadgramSplit <- strsplit(as.character(quadgramBasic$Tokenizer),split=" ")
quadgram <- transform(quadgramBasic,first = sapply(quadgramSplit,"[[",1),second = sapply(quadgramSplit,"[[",2),third = sapply(quadgramSplit,"[[",3),fourth = sapply(quadgramSplit,"[[",4))
saveRDS(quadgram,"./RData/quadgram.RData")
