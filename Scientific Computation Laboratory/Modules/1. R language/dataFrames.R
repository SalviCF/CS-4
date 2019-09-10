# Create a data frame

names <- c("Pepe", "Carla", "Antonio")
ages <- c(20, 21, 22)

df <- data.frame(alumns = names, age = ages, stringsAsFactors = F); df

# Accesing 

df$alumns # factor if stringAsFactor != F
class(df$alumns)
df[1] # data frame
class(df[1]) 

df$age # numeric
class(df$age)
df[2] # data frame
class(df[2])

# Using [] returns a data frame (column). Using [[]] returns the element inside
df[1]; class(df[1])
df[[1]]; class(df[[1]]) # equivalent to df$alumns

df[1:2] # columns 1 and 2
df[2:1] # columna 2 and 1
df[1,2] # 1st row 2nd column
df[1,] # all 1st row
df[1:2, ] # rows 1 and 2 and with all columns
df[1:2, ]$alumns # alumns of that subframe
df[2:1, ]$age # ages of that subframe (notice order)
df[,1] # column 1

# Data frame combination
# Combining two lists
alu1 <- list(name = "Luis", no.asig = 3, na.asig = c("Lab1", "Lab2"))
df1 <- as.data.frame(alu1); df1

alu2 <- list(name = "Antonio", no.asig = 3, na.asig = c("Lab4", "Lab1"))
df2 <- as.data.frame(alu2); df2

rbind(df1, df2) # combines two lists
as.data.frame(rbind(alu1, alu2)) # this isn't equivalent
rbind(as.data.frame(alu1), as.data.frame(alu2))


# Append column to data frame
dfa <- as.data.frame(list(surname = "Ruiz", city = c("Madrid", "Sevilla", "Valencia")))
cbind(df, dfa)

# Merge (column intersection)
my.df <- data.frame(name = c("Pepe", "Carla", "Antonio"), age = c(20, 21, 22))
my.df2 <- data.frame(name = c("Pepe", "Laura", "Carla"), id = c(0,3,5))
my.df3 <- merge(my.df, my.df2, by = "name")

# Queries
my.dataset <- data.frame(
  city=c('Madrid','Sevilla','Valencia','Madrid','Sevilla'),
  season=c('Winter','Spring','Autumn','Autumn','Summer'),
  temp =c(37.4,36.3,38.6,37.2,38.9)
  )
my.dataset$city
my.dataset$city[1]
my.dataset$city[[1]] # equivalent to previous one
my.dataset$city[my.dataset$season=="Summer"] # condition
# my.dataset$season=="Summer" returns a boolean vector

# Maintain data frame structure
df <- data.frame(exam1=c(7,8,5), exam2=c(4,9,8))
class(df$exam2)
class(df[1:3, 2, drop = F]) # maintain data frame structure
df[df$exam1 >= 7 , ] # filtering (don't forget columns)
subset(df, exam1 >= 7) # equivalent

df <- data.frame(exam1=c(7,8,5), exam2=c(4,NA,8))
df2 <- df[complete.cases(df) , ] # only the cases without NA

##################################################################

# Creating data frames #

kids <- c("Jack", "Jill")
ages <- c(12, 10)
d <- data.frame(kids, ages, stringsAsFactors = F)
class(d$kids) # character (not factor) because of stringAsFactors = F

###########################################################################

# Accesing dataframes # 

d[1] # 1st  column of the data frame (type data.frame)

d[[1]] # 1st column of the data frame (type of the original data)
d$kids # equivalent to d[[1]]
d[,1] # equivalent to d[[1]]

###########################################################################

# Extracting subdata frames #

exams.quiz <- data.frame(
  exam.1 = c(3,4,2.3,2.3), 
  exam.2 = c(2,4,0,1), 
  quiz = c(3.7,4,3.3,3.3))

exams.quiz[2:4, ] # shows rows 2 through 5 with all their columns
exams.quiz[2:4, 2] # shows rows 2 through 5 but only 2nd column

exams.quiz[2:4, 2, drop = F] # maintains data.frame structure

# students whose 1st exam score was > 2.5
exams.quiz[exams.quiz$exam.1 > 2.5 ,] # don't avoid NA

###########################################################################

# Treatment of NA values # 

exams.quiz$exam.1[2] <- NA
subset(exams.quiz, exam.1 > 2.5, quiz) # avoids NA

###########################################################################

# rbind() and cbind() #

rbind(d, list("Laura", 19))

# Creating new columns from older ones

cbind(d, diff = exams.quiz$exam.1 - exams.quiz$exam.2)
exams.quiz$examDiff <- exams.quiz$exam.1 - exams.quiz$exam.2

# Using recycle

d$one <- 1

###########################################################################

# apply() #

apply(exams.quiz, 1, max, na.rm = T) # see ?apply

###########################################################################

# Merging data frames #

d1 <- data.frame(
  kids = c("Jack", "Jill", "Jillian", "John"), 
  states = c("CA", "MA", "MA", "HI"))

d2 <- data.frame(
  ages = c(10, 7,  12),
  kids = c("Jill", "Lillian", "Jack"))

d <- merge(d1, d2)

d3 <- data.frame(ages = c(10,12,7), pals = c("Jack","Jill","Lillian"))

# See ?merge
merge(d1,d3,by.x = "kids",by.y = "pals") # merges using kids from d1 and pals from d3 

# Possibly indesirable behaviours
d2a <- rbind(d2,list(15,"Jill"))

merge(d1,d2a) # it assumes that Jill from d2a lives in MA... incorrect

###########################################################################

# Applying functions to data frames #

# lapply() and sapply()
d.sort <- lapply(d, sort) # sorts the data frame by columns

## Coercing to be a data frame
as.data.frame(d.sort) # this makes no sense because the correspondence has been lost... 
