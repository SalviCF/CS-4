## ----eval=FALSE,warning=FALSE,message=FALSE------------------------------
## Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud",
## "biclust", "cluster", "igraph", "fpc")
## install.packages(Needed, dependencies=TRUE)
## #install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/",  type = "source")
## install.packages("pdftools")

## ------------------------------------------------------------------------
library(tm)
library(pdftools)
library(stringr)
library(stringi)


## ------------------------------------------------------------------------
# En Mac -  si son ficheros pdf (necesitas pdftotext instalado en Mac)
# O para convertir pdf a texto es posible usar paquete R pdftools
#library(pdfinfo)
# 'pdfinfo' is not available (for R version 3.5.0)

directorio.textos <- file.path("~", "Desktop", "texts_Alz")

#On Windows
#directorio.textos <- file.path("C:", "texts")

directorio.textos
dir(directorio.textos)

#Leer los nombres de los ficheros
list.files <- DirSource(directorio.textos)

# Si es un fichero de texto  
# docs <- Corpus(DirSource(directorio.textos))


Rpdf <- readPDF(control = list(text = "-layout"))

# Crear Corpus
docs <- Corpus(URISource(list.files), 
               readerControl = list(reader = Rpdf))
docs
docs[1]
summary(docs)


## ------------------------------------------------------------------------
options(stringsAsFactors = FALSE)


## ----eval=TRUE, echo=TRUE, results='hide'--------------------------------
#Compactar palabras, eliminar patrones, etc. 
sub('thank you','thanks', docs,ignore.case = TRUE)
sub('pls','please', docs,ignore.case = TRUE)


## ----eval=TRUE, echo=TRUE------------------------------------------------
micad <- "We'll bes sure to send Jon Katz some kudos on your behalf on tuesday to bes punished"
micad <- sub("to","TO",micad)
micad
micad <- gsub("bes","be",micad)
micad

# COPIAR Y PEGAR EN LA CONSOLA
#lista.cadenas.reemplazar <- c("We'll","Jon Katz", "tuesday")
#lista.nueva.cadenas <- c("We will","J.K.", "Tuesday")
#micad <- mgsub(lista.cadenas.reemplazar,lista.nueva.cadenas,micad)
#micad



## ----eval=TRUE, echo=TRUE, results='hide'--------------------------------
#Compactar palabras, eliminar patrones, etc. 
micad <- "We'll be sure,  we'll be, to send Jon Katz some kudos on your behalf on tuesday to bes punished"
gsub('we\'ll','we are',micad,ignore.case = TRUE)


## ----eval=TRUE, echo=FALSE, results='hide'-------------------------------
gsub('[[:punct:]]','',textos$text,ignore.case = TRUE)


## ----eval=TRUE, echo=FALSE, results='hide'-------------------------------
# copiar y pegar en la consola
#meses <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
#num.meses <- 1:12
#textos$month <- mgsub(meses,num.meses,textos$month)
#textos$the.date <- paste(textos$date,textos$month,textos$year,sep='-')


## ----eval=TRUE, echo=FALSE, results='hide'-------------------------------
stri_count(head(textos$text),fixed = 'is')
stri_detect(head(textos$text),fixed = 'is')
# Detectar ciertos patrones
patrones <- with(textos,str_detect(textos$text,'sorry')&str_detect(textos$text,'problem') )
textos[patrones,5]

