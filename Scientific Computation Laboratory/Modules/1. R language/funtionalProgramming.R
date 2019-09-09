# Functional Programming #

# aplly() familiy

plus.one <- function(x) x+1
numbers <- list(1,2,3,4,5)
lapply(numbers, plus.one)
sapply(numbers, plus.one)

lapply(1:5, plus.one) # also works

names <- c("PEPE","LUIS","CLARA")
lapply(names, tolower)

grades <- list(c(2.5,7.8,3,7), c(9.3,2.1,6.5))
sapply(grades, mean) # returns a vector

min.max <- function(x) list(min(x),max(x))
sapply(grades, min.max)# returns a matrix

data("airquality")
View(airquality)
sapply(airquality, mean, na.rm = T)

# tapply() (Temporarily split and apply)

initials <- c("S","C","F") 
ages <- c(20,21,22)

tapply(ages, initials, mean) # age mean of the groups marked by initials
tapply(airquality$Temp, airquality$Month, mean) # temperature mean by month

d <- data.frame(gender = c("M","M","F","M","F","F"), 
                age = c(47,59,21,32,33,24), 
                income = c(55000,88000,32450,76500,123000,45650))

d$over25 <- ifelse(d$age > 25,1,0)
tapply(d$income, list(d$gender,d$over25), mean)

###################################################################################################

# Split #
v <- 1:100
f <- gl(10,10) # (#levels,#repetitions)
groups <- split(v,f) # 10 groups of 10 elements
lapply(groups, mean) # mean by each group

by.month <- split(airquality,airquality$Month) # split by month
sapply(by.month, function(x) mean(x[,"Wind"])) # mean of Wind by months

split(d$income,list(d$gender,d$over25)) # 



