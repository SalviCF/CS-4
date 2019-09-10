library(tm)
library(pdftools)
library(stringr)
library(stringi)

directorio.textos <- file.path("~", "Desktop", "texts_Alz")

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

options(stringsAsFactors = FALSE)

#Compactar palabras, eliminar patrones, etc. 
sub('thank you','thanks', docs,ignore.case = TRUE)
sub('pls','please', docs,ignore.case = TRUE)

micad <- "We'll bes sure to send Jon Katz some kudos on your behalf on tuesday to bes punished"
micad <- sub("to","TO",micad)
micad
micad <- gsub("bes","be",micad)
micad

#lista.cadenas.reemplazar <- c("We'll","Jon Katz", "tuesday")
#lista.nueva.cadenas <- c("We will","J.K.", "Tuesday")
#micad <- mgsub(lista.cadenas.reemplazar,lista.nueva.cadenas,micad)
#micad

#Compactar palabras, eliminar patrones, etc. 
micad <- "We'll be sure,  we'll be, to send Jon Katz some kudos on your behalf on tuesday to bes punished"
gsub('we\'ll','we are',micad,ignore.case = TRUE)


gsub('[[:punct:]]','',textos$text,ignore.case = TRUE)

#meses <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")
#num.meses <- 1:12
#textos$month <- mgsub(meses,num.meses,textos$month)
#textos$the.date <- paste(textos$date,textos$month,textos$year,sep='-')

stri_count(head(textos$text),fixed = 'is')
stri_detect(head(textos$text),fixed = 'is')
# Detectar ciertos patrones
patrones <- with(textos,str_detect(textos$text,'sorry')&str_detect(textos$text,'problem') )
textos[patrones,5]
