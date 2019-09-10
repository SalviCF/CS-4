library(arules)
library(readr)
lastfm <- read_csv("lastfm.csv")
lastfm[1:20,]
length(lastfm$user)   ## 289,955 filas
class(lastfm$user)
# Necesitamos convertir este atributo a factor
# para poder analizarlo con paquete {\tt arules}

lastfm$user <- factor(lastfm$user)
# levels(lastfm$user)  ## 15,000 users
# levels(lastfm$artist)  ## 1,004 artists

reglas1 <- apriori(lastfm,parameter=list(support=.01, confidence=.5))
inspect(reglas1)

lista.musica.por.usuario <- split(x=lastfm[,"artist"],f=lastfm$user)
lista.musica.por.usuario[1:2]

## Eliminar duplicados  
lista.musica.por.usuario <- lapply(lista.musica.por.usuario,unique)

# Convertimos en transacciones la lista de música
lista.musica.por.usuario1 <- as(lista.musica.por.usuario,"transactions")

lista.musica.por.usuario[1:5]

#lista.musica.por.usuario2 <- as(lapply(lista.musica.por.usuario, "[[", 1), "transactions")
#lista.musica.por.usuario2

str(lista.musica.por.usuario1)
write(head(lista.musica.por.usuario1))
write(head(lista.musica.por.usuario1),format="single")

itfreq1  <-itemFrequency(lista.musica.por.usuario1)
head(itfreq1)

itemFrequencyPlot(lista.musica.por.usuario1,support=.08,cex.names=1)

reglas2 <- apriori(lista.musica.por.usuario1,parameter=
                     list(support=.01, confidence=.5))
reglas2
inspect(reglas2)

inspect(subset(reglas2, subset=lift > 1))

inspect(sort(subset(reglas2, subset=lift > 1), by="confidence"))

r1 <-subset(reglas2, subset = lhs %ain% 
         c("coldplay"))
inspect(r1)
