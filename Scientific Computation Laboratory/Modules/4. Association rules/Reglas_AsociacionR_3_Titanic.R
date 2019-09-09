## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)


## ---- echo=TRUE,eval=TRUE,display=TRUE,warning=FALSE---------------------
# Instalar sólo la primera vez:

#install.packages('arules' , repos="http://cran.rstudio.com")
#install.packages('arulesViz', repos="http://cran.rstudio.com" )

library('arules')
library('arulesViz')
library('repmis')


## ---- echo=TRUE,eval=TRUE,display=TRUE,warning=FALSE---------------------
source_data("http://www.rdatamining.com/data/titanic.raw.rdata?attredirects=0&d=1")


## ---- echo=FALSE,eval=TRUE,display=TRUE----------------------------------
idx <- sample(1:nrow(titanic.raw), 5)
titanic.raw[idx, ]
class(titanic.raw)
summary(titanic.raw)


## ---- echo=FALSE,eval=TRUE,display=TRUE----------------------------------
 system.time(R1 <- apriori(titanic.raw))
inspect(R1[1:10])


## ---- echo=FALSE,eval=TRUE,display=TRUE----------------------------------
R1 <- apriori(titanic.raw)
inspect(R1)

# Rules with rhs containing "Survived" only
R2 <- apriori(titanic.raw,
                 control = list(verbose=FALSE),
                 parameter = list(minlen=2, supp=0.005, conf=0.8),
                 appearance = list(rhs=c("Survived=No",
                                         "Survived=Yes"),
                                   default="lhs"))
inspect(R2)


## ---- echo=FALSE,eval=TRUE,display=TRUE----------------------------------
quality(R2) <- round(quality(R2), digits=3)



## ---- echo=FALSE,eval=TRUE,display=TRUE----------------------------------
R2ord <- sort(R2, by="confidence")

inspect(R2ord)



## ---- echo=FALSE,eval=TRUE,display=TRUE,warning=FALSE--------------------
plot(R2ord)

plot(R2ord, method = "grouped")

plot(R2ord, method = "graph")

plot(R2ord, method = "graph", control = list(type = "items"))

plot(R2ord, method = "paracoord", control = list(reorder = TRUE))


## ---- echo=TRUE,eval=TRUE,display=TRUE-----------------------------------
 inspect(R2ord[1:2])


## ---- echo=TRUE,eval=TRUE,display=TRUE-----------------------------------
inspect(R2ord[1:2])
M1 <- is.subset(R2ord[1:2], R2ord[1:2])
M1
colnames(M1) <- c('r1','r2')
row.names(M1) <- c('r1','r2')
M1
# la regla R1 está incluida en la regla R2


## ---- echo=TRUE,eval=TRUE,display=TRUE-----------------------------------
inspect(R2ord)
M1 <- as.matrix(is.subset(R2ord, R2ord))
M1[lower.tri(M1, diag = T)] <- NA
redundantes <- colSums(M1, na.rm = T) >= 1
## Reglas redundantes
which(redundantes)


## ---- echo=TRUE,eval=TRUE,display=TRUE-----------------------------------

## Ver las no redundantes
R2ord.noredun <- R2ord[!redundantes]
inspect(R2ord.noredun)
# Ver las redundantes
R2ord.redun <- R2ord[redundantes]
inspect(R2ord.redun)


