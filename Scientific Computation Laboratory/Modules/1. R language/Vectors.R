# Interesting functionalities of vectors

# Inserts 168 before the 13
x <- c(88,5,12,13)
x <- c(x[1:3], 168, x[4]) # creates a new vector ans stores that vector in x

# Length of a vector
length(x)

# Determines the index of the first 1 in the vector 
first1_for <- function(x) {
  for (i in 1:length(x)) {
    if (x[i] == 1) return(i)
  }
}

# Equivalent to the previous but without loop
first1_which <- function(x) {
  which(v == 1)[1]
}

# Avoiding problems with the empty vector
first1_seq <- function(x) {
  for (i in seq(x)) {
    if (x[i] == 1) return(i)
  } 
}

# One way of naming vector elements
y <- c(elem=10:1)

# Initialize vector 
y <- vector(length = 4)
y[1] <- 2; y[2] <- 4

# Matrices and arrays are also vectors
m <- 1:6 
dim(m) <- c(3,2) # m is stored by columns
m + c(1,2)

# R is a functional language
"+" (2,3) # operators are functions

# Vector indexing: we select those elements of vector1 whose indices are given in vector2
vector1 <- c(2,7,4,9,1)
vector2 <- c(1,1,2,2,3,4)
vector1[vector2]
vector1[2:3]
vector1[c(2,3,2)]

z <- c(5,12,13)
z[-1]
z[-1:-3]
z[-c(1,2)]
z[c(-1,-3)]
z[-(2:3)]
z[-length(z)] # excluding the last element

# Help for precedence operators: ?Syntax
i <- 2
1:i-1 # this means (1:i) - 1
1:(i-1)

# Sequences
seq(from=12, to=30, by=3)
seq(from=0.5, to=3.5, length.out=10)
seq(c()) # useful in for loops
seq(NULL)

seq_len(0)
seq_along(1:6) # creates a sequence from 1 to input's length

# Repeating
x <- rep(8,4)
x <- rep(x, 2)
rep(1:5, 2)
rep(c(4,8,2), 5)
rep(c(1,3,5), each=2)
rep(c(1,3,4), length.out=15)

# All and any
all(c(1:10) > 5)
any(c(1:10) > 5)
all(c(1:10) > -3)
any(c(1:10) == 45)

# Vector in, matrix out
z12 <- function(z) return(c(z, z^2))
z12(1:5) # result is a vector

matrix(z12(1:5), ncol = 2)
# Simplify Apply
sapply(1:8, z12) # applies z12 to each element in 1:8 and returns a matrix

# Skip over NA's
mean(c(3,76,NA,22), na.rm = T)
mean(c(3,76,NULL,22)) # R naturally skips over NULL values

# Building vectors in loops
w <- NULL
for(i in 1:10) if (i%%2 == 0) w <- c(w,i)

# Filtering
# Extracts those elements whose squares are greater than 8
z <- c(5,2,-3,8)
z[z*z > 8] # z*z > 8 outputs a vector of booleans
# Finally, we extract the elements indicated by boolean vector

y <- c(1,2,30,5)
y[z*z > 8]

# Replacing all elements greater than 3 by a 0
x <- 1:5
x[x > 3] <- 0


# Filtering with subset(): get rid off NA's
x <- c(4,2,6,NA)
x[x > 4] # the NA appears in the result
subset(x, x > 5) # NA does not appear

# Extracting the positions, not the elements
z <- c(5,2,-3,8)
z[z*z > 8] # returns the values
which(z*z > 8) # returns the positions
which.max(z) # more efficient that which(max(z))

# The ifelse() function (vectorized version)
x <- 1:10
ifelse(x %% 2 == 0, "even", "odd") # "even" and "odd" are vectors (recycle)

# Testing vector equality
x <- 1:3
y <- c(1,4,3)
x == y
all(x == y)
identical(x,y)

# Be careful using identical()
x <- 1:3
y <- c(1,2,3)
identical(x,y)
typeof(x)
typeof(y)
# : produces integers while c() produces floating-point numbers

# Naming vector elements
x <- 1:3
names(x) # returns NULL
names(x) <- c("Salvador", "C", "F"); x
names(x)[1] <- "Salvi"; x
x["Salvi"]# referencing by name
names(x) <- NULL # to remove the names
x <- c(apples = 1, bananas = 3, "kiwis" = 7, "orange juice" = 2)

# Flattening effect
c(1,2,4,c(5,6,7))

vector("numeric", 5)
numeric(5)
vector("character", 5)
vector("list", 5)

# Lenght of each string 
ss <- c("Salvi", "loves", "computer", "science")
nchar(ss)
