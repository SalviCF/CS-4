# Explicit printing
for (i in 1:10) i # does not print i
for (i in 1:10) print(i) # now, it prints

# Summary function
x <- 1:5
summary(x)

# Visualizing data frames
View(UKgas)
View(head(UKgas))

# Hidding variables 
.hidden <- 5 # starts with a point 
ls()
ls(all.names = T) # to see hidden vars

# Debbuging
browseEnv()
ls.str()

# Clean up the workspace
rm(list = ls())

# There are several functions that let you inspect variables:
#   summary, head, str, unclass, attributes, and View.

# Finding out if there is NA's 
v <- c(8,3,2,NA,NA,4,8)
is.na(v)
as.logical(sum(is.na(v))) # solution 1
any(is.na(v)) # solution 2

# Indexing
v[v > 5] # elements greater than 5
which(v > 5) # positions of the elements greater than 5
v[v < mean(v)] # elements smaller than the mean

# Some exercises 
v <- c(1,3,1.2,2,1,2,5,6,3,2)
sort(v) 
sort(v, decreasing = TRUE) # more efficient than rev
rev(v) # reverse
unique(v) # remove repeated elements
diff(1:5) # [2-1, 3-2, 4-3, 5-4]; default lag=1
diff(1:5, 2) # with lag=2; [3-1, 4-2, 5-3] 
order(c(1,1,3:7,12:10)) # returns the indices of a sorted vector with respect to the original vector
sample(5) # returns a random sample of the elements of a vector; ?sample
sample(c("even", "odd"), 5, replace = T)
v[order(v)] # same effect as if we sort the vector

# NA management
v <- w <- c(1,2,NA,5,NA,8)
# v == NA # the result is not a logic vector (waring arises, recommend is.na)
v[is.na(v)] <- 0 # replacing NA by 0

# Append (see ?append)
v <- 1:10
append(v, c(1.2,3.3), after = 2) # inserts 1.2 and 3.3 after the 2nd position
