## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)


## ----echo=TRUE-----------------------------------------------------------
library(arules)
data("Adult")
length(Adult)
dim(Adult)
Adult
inspect(Adult[1:2])


## ----echo=TRUE-----------------------------------------------------------
data("Adult")
 rules <- apriori(Adult,  parameter = list(supp = 0.5, conf = 0.9,   
target = "rules")) 
summary(rules) 
inspect(rules)


## ----echo=TRUE, eval=FALSE-----------------------------------------------
## rules <- apriori(Adult,  parameter = list(supp = 0.5, conf = 0.9,minlen=2))


## ----echo=TRUE, eval=FALSE-----------------------------------------------
## rules <- apriori(Adult,  parameter = list(supp = 0.5, conf = 0.9), appearance = list(items = c("income=small", "sex=Male"))
## 
## 
## rules <- apriori(Adult,  parameter = list(supp = 0.5, conf = 0.9), appearance = list(none = c("income=small", "sex=Male")))
## 


## ----echo=TRUE-----------------------------------------------------------
data("AdultUCI")
View(AdultUCI)
str(AdultUCI)


## ----echo=TRUE-----------------------------------------------------------
AdultUCI$fnlwgt <-NULL  
## o  AdultUCI[["fnlwgt"]] <- NULL

AdultUCI$`education-num` <- NULL 


## ----echo=TRUE-----------------------------------------------------------
# ejemplo de funcionamiento de cut y ordered
v <- 1:100
v2 <- cut(v,c(0,25,50,75,100),labels=c("bajo","medio","alto","muyalto"))
?ordered
v3 <- ordered(v2)


## ----echo=TRUE-----------------------------------------------------------

AdultUCI$age <- ordered(cut(AdultUCI[[ "age"]], c(15,25,45,65,100)),
  labels = c("Young", "Middle-aged", "Senior", "Old"))

AdultUCI[[ "hours-per-week"]] <- ordered(cut(AdultUCI[[ "hours-per-week"]],
  c(0,25,40,60,168)),
  labels = c("Part-time", "Full-time", "Over-time", "Workaholic"))

AdultUCI[[ "capital-gain"]] <- ordered(cut(AdultUCI[[ "capital-gain"]],
  c(-Inf,0,median(AdultUCI[[ "capital-gain"]][AdultUCI[[ "capital-gain"]]>0]),
  Inf)), labels = c("None", "Low", "High"))

AdultUCI[[ "capital-loss"]] <- ordered(cut(AdultUCI[[ "capital-loss"]],
  c(-Inf,0, median(AdultUCI[[ "capital-loss"]][AdultUCI[[ "capital-loss"]]>0]),
  Inf)), labels = c("None", "Low", "High"))




## ----echo=TRUE-----------------------------------------------------------
reg <- apriori(AdultUCI)
inspect(head(reg))


## ----echo=TRUE-----------------------------------------------------------
Adult1 <- as(AdultUCI, "transactions")
class(Adult1)
length(Adult1)
dim(Adult1)
Adult1
inspect(Adult1[1:2])


## ----echo=TRUE-----------------------------------------------------------
data("Adult")
class(Adult)
length(Adult)
dim(Adult)
Adult
inspect(Adult[1:2])

