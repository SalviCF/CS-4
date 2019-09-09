# Package data.table #

# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html

# To use the package 

library(data.table)

# 1. Create a data.table

dt <- data.table(a = c(1L,2L), b = LETTERS[1:4]) # 1L and 2L are recycled. LETTERS is a built-in constant

# 2. Obtain elements: dt[row,column,by]. We use by to grouping

dt[3,] # 3rd row
dt[,2] # 2nd column
dt[3,2] # 3rd row 2th column
dt[3:4] # 3rd and 4th rows
dt[.N] # shows the last row
dt[nrow(dt)] # also shows the last row
tail(dt,1) # also shows the last row
head(dt,1) # shows the first row

dt <- data.table(A = 1:5, B = letters[1:5], C = 6:10)
dt[,B] # the column is shown as a vector
dt[,.(B)] # now, the column is shown as a data frame

DT <-data.table(name = c("Tom", "Boris", "Jim"),
                eye_color = c("Brown", "Blue", "Blue"),
                height = c(169, 171, 168))

DT[, .(name,eye_color)] # selects that columns
DT[, 1:2] # equivalent to the previous line
DT[, .(name,height_ft = height/30.48)] # selects that columns. Creates a new column from the previous one

data.table(iris)
dt <- as.data.table(iris)
dt[, .(Count = .N), by = .(Area = 10 * round(Sepal.Length * Sepal.Width/10))]

DT <- data.table(A = rep(letters[2:1], each = 4L),
                 B = rep(1:4, each = 2L),
                 C = sample(8))

DT2 <- DT[, .(C =cumsum(C)), by = .(A, B)]
DT2

DT2[, .(C =tail(C, 2)), by = A]

# Chaining 1
DT[, .(C=cumsum(C)),by = .(A,B)][, .(C=tail(C,2)),by=A]

# Chaining 2
DT <- as.data.table(iris)
DT[,.(Sepal.Length = median(Sepal.Length),
      Sepal.Width = median(Sepal.Width),
      Petal.Length = median(Petal.Length),
      Petal.Width = median(Petal.Width)),
      by = Species][order(-Species)]

DT <- data.table(Sex=c("M","F","F","M","M"),
                 Weight=c(60,50,85,88,48),
                 Age=c(11,7,19,20,13),
                 Height=c(167,160,175,177,160))

DT[, lapply(.SD, mean), by = Sex]

# Adding, modifying and deleting columns
DT <- data.table(A = letters[c(1,1,1,2,2)],B = 1:5)
DT[, C := c(22,39,10,-55,300)]
DT[, C := C*10]
DT[, C := NULL]

# set()

DT <- data.table(Sex=c("M","F","F","M","M"),
                 Weight=c(60,50,85,88,48),
                 Age=c(11,7,19,20,13),
                 Height=c(167,160,175,177,160))

for (i in 2:4) set(DT, c(1L,3L), i, NA)

# Selecting rows
iris <- as.data.table(iris)
iris[Species == "virginica"]
iris[Species %in% c("virginica", "versicolor")]

setnames(iris,gsub("^Sepal\\.", "",names(iris)))
iris[,grep("^Petal",names(iris)):=NULL]



