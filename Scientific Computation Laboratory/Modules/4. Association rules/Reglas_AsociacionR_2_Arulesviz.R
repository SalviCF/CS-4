## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)


## ------------------------------------------------------------------------
library(arules)
library(arulesViz)
data(Groceries)
rules <- apriori(Groceries, parameter=list(support=0.001, confidence=0.5))
rules
inspect(head(rules))


## ------------------------------------------------------------------------
plot(rules)
library(colorspace)  
plot(rules, control = list(col=sequential_hcl(100)))
plot(rules, col=sequential_hcl(100))
plot(rules, col=grey.colors(50, alpha =.8))


## ----eval=FALSE----------------------------------------------------------
## #Ejecutar en vuestro ordenador
## sel <- plot(rules, engine = "interactive")
## plot(rules, engine = "htmlwidget")


## ------------------------------------------------------------------------
subrules <- subset(rules, lift>8)
subrules
plot(subrules, method="matrix")
plot(subrules, method="matrix", engine = "3d")
plot(subrules, method="matrix", shading=c("lift", "confidence"))


## ---- eval=FALSE---------------------------------------------------------
## # Ejecutar en vuestro ordenador
## plot(subrules, method="matrix", engine="interactive")
## plot(subrules, method="matrix", engine="htmlwidget")


## ---- eval=FALSE---------------------------------------------------------
## # Ejecutar en vuestro ordenador
## plot(subrules, method="grouped matrix")
## plot(subrules, method="grouped matrix",
##      col = grey.colors(10),
##      gp_labels = gpar(col = "blue", cex=1, fontface="italic"))
## #sel <- plot(rules, method="grouped", engine = "interactive")


## ------------------------------------------------------------------------
subrules2 <- sample(subrules, 5)
plot(subrules2, method="graph")
plot(subrules2, method="graph", 
     nodeCol = grey.colors(10), edgeCol = grey(.7), alpha = 1)


## ------------------------------------------------------------------------
plot(subrules2, method="graph", engine="graphviz")


## ----eval=FALSE----------------------------------------------------------
## # Ejecutar en local
## plot(subrules2, method="graph", engine="htmlwidget")
## plot(subrules2, method="graph", engine="htmlwidget",
##      igraphLayout = "layout_in_circle")


## ---- echo=FALSE,eval=TRUE,display=TRUE----------------------------------
rules <- apriori(Groceries, parameter=list(sup=0.01 , conf=0.1))


## ---- echo=FALSE,eval=TRUE,display=TRUE----------------------------------
rules


## ---- echo=FALSE,eval=TRUE,display=TRUE----------------------------------
Rules1 <- head(sort(rules , by="lift") , 5)
inspect(head(Rules1))


## ---- echo=FALSE,eval=TRUE,display=TRUE----------------------------------
Rules2 <- rules[quality(rules)$confidence > 0.5]
inspect(head(Rules2))


## ---- echo=FALSE,eval=TRUE,display=TRUE----------------------------------
out1=as(Rules2,'data.frame')
plot(out1)
View(out1)


## ---- echo=TRUE,eval=TRUE,display=TRUE-----------------------------------
saveAsGraph(head(sort(Rules2, by="lift"),1000), file="rules.graphml")


