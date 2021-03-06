library('arules')
library('arulesViz')
library('repmis')

source_data("http://www.rdatamining.com/data/titanic.raw.rdata?attredirects=0&d=1")
R1 <- apriori(titanic.raw,
                 control = list(verbose=FALSE),
                 parameter = list(minlen=2, supp=0.005, conf=0.8))


R1_no_survived  <- subset(R1, items %in% "Survived=No")
inspect(head(R1_no_survived))

lhs(R1_no_survived[1])
inspect(lhs(R1_no_survived[1]))
inspect(rhs(R1_no_survived[1]))
class(lhs(R1_no_survived[1]))

write(R1_no_survived, file = "reglas1_titanic.csv",
      sep = ",", quote = TRUE, row.names = FALSE)


library(pmml)
### save rules as PMML
write.PMML(R1_no_survived, file = "R1_no_survived.xml")

### read rules back
reglas2 <- read.PMML("R1_no_survived.xml")

R1_no_survived_df <- as(R1, "data.frame")
str(R1_no_survived_df)

rules <- apriori(titanic.raw, parameter = list(support = 0.5))
is.significant(rules, titanic.raw)

inspect(rules[is.significant(rules, titanic.raw)])

## mi.dataset$edad <- mi.dataset$edad<18
## d$height <- discretize( mi.dataset$edad, method = "frequency", 4)
## AdultUCI <- lapply(mi.dataset, function(x){as.factor(x)})

subrules = R1[quality(R1)$confidence > 0.8];
subrules

R1Support = quality(R1)$support

subsetR1 <- which(colSums(is.subset(R1, R1)) > 1) # get subset rules in vector
length(subsetR1)   
R1_no_redundantes <- R1[-subsetR1] # remove subset rules. 

R1_no_redundantes
R1_no_redundantes_1 <- R1[-is.redundant((R1))]
R1_no_redundantes_1

itemFrequencyPlot(items(R1_no_survived), topN=30, cex.names=.6)

data(Adult)
itemFrequencyPlot(Adult, support = 0.1, cex.names=0.8)
itemFrequencyPlot(Adult, topN=10, type="absolute", main="Item Frequency") 

mi.itemsets = eclat(Adult, parameter = list(support = 0.05), control = list(verbose=FALSE))
# Obengo los 1-itemsets
itemsets1 = mi.itemsets[size(items(mi.itemsets)) == 1];

saveAsGraph(sort(R1_no_redundantes_1, by = "lift"), file = "R1_no_redundantes_1.graphml")
