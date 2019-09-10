## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ----echo=TRUE-----------------------------------------------------------
library(arules)
lastfm <- read.csv("lastfm.csv")
lastfm[1:20,]
length(lastfm$user)   ## 289,955 filas
class(lastfm$user)
# Necesitamos convertir este atributo a factor
#para poder analizarlo con paquete {\tt arules}

lastfm$user <- factor(lastfm$user)
# levels(lastfm$user)  ## 15,000 users
# levels(lastfm$artist)  ## 1,004 artists


## ---- echo=TRUE----------------------------------------------------------
reglas1 <- apriori(lastfm,parameter=list(support=.01, confidence=.5))
inspect(reglas1)


## ---- echo=TRUE----------------------------------------------------------
lista.musica.por.usuario <- split(x=lastfm[,"artist"],f=lastfm$user)
lista.musica.por.usuario[1:2]


## ---- echo=TRUE----------------------------------------------------------
## Eliminar duplicados  
lista.musica.por.usuario <- lapply(lista.musica.por.usuario,unique)

# Convertimos en transacciones la lista de música.
lista.musica.por.usuario1 <- as(lista.musica.por.usuario,"transactions")

lista.musica.por.usuario[1:5]

#lista.musica.por.usuario2 <- as(lapply(lista.musica.por.usuario, "[[", 1), "transactions")
#lista.musica.por.usuario2


## ---- echo=TRUE----------------------------------------------------------
str(lista.musica.por.usuario1)
write(head(lista.musica.por.usuario1))
write(head(lista.musica.por.usuario1),format="single")


## ---- echo=TRUE----------------------------------------------------------
itfreq1  <-itemFrequency(lista.musica.por.usuario1)
head(itfreq1)


## ---- echo=TRUE----------------------------------------------------------
itemFrequencyPlot(lista.musica.por.usuario1,support=.08,cex.names=1)


## ---- echo=TRUE----------------------------------------------------------
reglas2 <- apriori(lista.musica.por.usuario1,parameter=
                     list(support=.01, confidence=.5))
reglas2
inspect(reglas2)


## ---- echo=TRUE----------------------------------------------------------
inspect(subset(reglas2, subset=lift > 1))


## ---- echo=TRUE----------------------------------------------------------
inspect(sort(subset(reglas2, subset=lift > 1), by="confidence"))



## ---- echo=TRUE----------------------------------------------------------
r1 <-subset(reglas2, subset = lhs %ain% 
         c("coldplay"))
inspect(r1)

