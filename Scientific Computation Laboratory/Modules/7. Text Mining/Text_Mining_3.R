## ------------------------------------------------------------------------
library(tm)
library(pdftools)
library(stringr)
library(stringi)
library(ggplot2)
library(wordcloud)



## ------------------------------------------------------------------------
textos <- read.csv("./data/oct_delta.csv")
View(textos)
tweets <- data.frame(doc_id=seq(1:nrow(textos)), text=textos$text)



## ------------------------------------------------------------------------
# ?tm_map
# tm_map(documento,getTransformations)
# ?getTransformations
 
# Personalizar tu rutina de limpieza de texto depende del objetivo

# Personalizar lista de stopwords
my.stopwords <-c(stopwords('english'),'mi','etc')  
tail(my.stopwords)

clean.text <-function(Corpus,my.stopwords){
  Corpus <- tm_map(Corpus,content_transformer(tolower))
  Corpus <- tm_map(Corpus,removeNumbers)
  Corpus <- tm_map(Corpus,removeWords,my.stopwords)
  Corpus <- tm_map(Corpus,removePunctuation)
  Corpus <- tm_map(Corpus,stripWhitespace)
return(Corpus)  

}# end clean.text function
  
#  For a list of the stopwords, see: length(stopwords("english")), 



## ----eval=FALSE----------------------------------------------------------
## stopwords("english")
## corpus <- clean.text(tweets$text,stopwords("english"))
## tweets <- tm_map(tweets$text,removeWords, stopwords("english"))


## ------------------------------------------------------------------------
corpus <- Corpus(VectorSource(tweets$text))
corpus <- clean.text(corpus,stopwords("english"))
#primer documento
inspect(corpus[[1]])


## ------------------------------------------------------------------------
corpus <- tm_map(corpus,removeWords,c('aa'))
#primer tweet tras limpieza
# cadena aa eliminada
inspect(corpus[[1]])
corpus[[1]]$content
corpus[[1]]$meta


## ------------------------------------------------------------------------
# Ayuda: Comando seq que se usará en un for para ir seleccionando 
# los documentos de texto
head(seq(corpus)) 
#[1] 1 2


#Eliminar caracteres especiales
for (j in seq(corpus))
 {  corpus[[j]] <- gsub("/"," ",corpus[[j]])
    corpus[[j]] <- gsub("@"," ",corpus[[j]])
    corpus[[j]] <- gsub("\\|", " ", corpus[[j]])
 }
 
#Combinar palabras, sustituir unas por otras
for (j in seq(corpus))
{
  corpus[[j]] <- gsub("qualitative research", "QDA", corpus[[j]])
  corpus[[j]] <- gsub("research methods", "research_methods", corpus[[j]])
  corpus[[j]] <- gsub("corrupci<>n", "corrupción", corpus[[j]])
  corpus[[j]] <- gsub("instituci<>n", "institución", corpus[[j]])
}
inspect(corpus[1]); inspect(corpus[2])

#Eliminar cadenas especiales, palabras, etc. 

# Eliminar palabras individuales
corpus <- tm_map(corpus, removeWords, c("part", "someone", "aging"))
# Esto debería funcionar. Probar. ¿En Mac, no?

# tweets <- tm_map(tweets, removeWords, c("<d5>", "<d1>", "\f", "?", "<d1>"))
# Línea anterior comentada porque estos códigos no 
# vienen como una palabra, aparecen junto a palabras
    
# Otra posibilidad. Esto si funciona 
remove_string2 <- function(mycorpus){
  gsub("hobbies"," ",mycorpus)
}

corpus <- tm_map(corpus,remove_string2)
inspect(corpus[1]);inspect(corpus[2])

remove_string1 <- function(mycorpus){
  gsub("\n"," ",mycorpus);  gsub("<d5>"," ",mycorpus)
  gsub("<d1>"," ",mycorpus); gsub("\f"," ",mycorpus)
  gsub("?"," ",mycorpus); gsub("<d1>"," ",mycorpus)
  }
# Esto debería funcionar. Solo elimina la  primera cadena
corpus <- tm_map(corpus,remove_string1)
inspect(corpus[1]);inspect(corpus[2])

# Problemas con los tipos de codificación depende de tipo de equipo...
# Otros intentos?



## ------------------------------------------------------------------------
toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x))
corpus <- tm_map(corpus, toSpace, "\n")
corpus <- tm_map(corpus, toSpace, "<d5>")
corpus <- tm_map(corpus, toSpace, "<d1>")
corpus <- tm_map(corpus, toSpace, "\f")

#inspect(corpus[1]);inspect(corpus[2])



## ----eval=FALSE----------------------------------------------------------
## # Steam documents
## # Stem words in a text document using Porter's stemming algorithm.
## corpus <- tm_map(corpus, stemDocument)
## 
## #To treat your preprocessed documents as text documents.
## #corpus <- tm_map(corpus, PlainTextDocument)
## #inspect(corpus[1]);inspect(corpus[2])
## 


## ----eval=FALSE----------------------------------------------------------
## tm_map(corpus,function(x) iconv(enc2utf8(x), sub ="byte"))
## 


## ------------------------------------------------------------------------
dtm <- DocumentTermMatrix(corpus)
dtm
class(dtm)
str(dtm)
#If you prefer to export the matrix to Excel:
m <- as.matrix(dtm)
dim(m)
write.csv(m, file="dtm.csv")



## ------------------------------------------------------------------------
freq <- colSums(as.matrix(dtm))
length(freq)
ord <- order(freq)
dtms <- removeSparseTerms(dtm, 0.1) 
# This makes a matrix that is 10% empty space, maximum.
#Word Frequency
freq[head(ord)]
freq[tail(ord)]



## ------------------------------------------------------------------------
findFreqTerms(dtm, lowfreq=30)
wf <- data.frame(word=names(freq), freq=freq)
head(wf)


## ------------------------------------------------------------------------

p <- ggplot(subset(wf, freq>150), aes(word, freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p


## ------------------------------------------------------------------------
#?findAssocs
AS <-findAssocs(dtm, c("can" , "pleas"), corlimit=0.2) 
# specifying a correlation limit of 0.98
AS$can
AS$pleas



## ------------------------------------------------------------------------

set.seed(142)
wordcloud(names(freq), freq, min.freq=25)

#with colours
#Plot the 100 most frequently occurring words.
set.seed(142)
dark2 <- brewer.pal(6, "Dark2")
wordcloud(names(freq), freq, max.words=100, rot.per=0.2, colors=dark2)
#Word Clouds!
 
m <- as.matrix(dtm)
v <- sort(colSums(m),decreasing=TRUE)
head(v,14)
words <- names(v)
d <- data.frame(word=words, freq=v)
wordcloud(d$word,d$freq,min.freq=50)


