# Creating a matrix (2 dimension's vector)
matrix(1:4, nrow = 2, ncol = 2) # 1st way
array(1:3, c(2,4)) # 2nd way, matrices of n dimensions (3d: rows, columns and layers)
v <- 1:4; dim(v) <- c(2,2); v # 3rd way, changing a vector's dimensions

# rbind (combines by rows) and cbind (combines by columns)
f1 <- c(5,-8,1)
f2 <- c(4,5,2)
f3 <- c(3,3,-4)
mr <- rbind(f1,f2,f3); mr
mc <- cbind(f1,f2,f3); mc

# Parameter byrow
A <- matrix(c(pi, sqrt(2), 12, 54), 2, 2, byrow = T)
# by default, byrow = F

# Warning: recycling
m <- matrix(2*(1:4), 2, 3)
m + c(1,2)

# Indexing
v1 <- m[m > 4]; v1 # values greater than 4
i1 <- which(m > 4); i1 # positions of values greater than 4

m[2,2] # [row, column]
m[,2] # entire 2nd column
m[,1:2] # first 2 columns
m[1:2,2:3] # rows 1 and 2 and columns 2 and 3
m[c(2,1), c(2,1)] # changing order

# Assigning values to submatrices
m[1:2, c(1,3)] <- matrix(c(1,1,8,12),nrow=2) 

x <- matrix(NA,3,3)
y <- matrix(c(7,3,2,1), 2,2)
x[2:3,2:3] <- y


# Matrix operations
A <- matrix(1:4, 2, 2)
B <- matrix(5:8, 2, 2)

A + B # sum by element
A * B # multiplication by element
2 * B # multiplcation by a scalar

A %*% B # matrix multiplication
matrix(1:6, 2,3) %*% matrix(1:4, 2,2) # 1st matrix ncols doesn't match 2nd nrows 

t(A) # Transposed
det(A) # Determinant
diag(A) # Main diagonal

# Solving a system equation (Ax = b)
b <- c(2,3)
x <- solve(A, b); x

# Eigenvalues and eigenvectors
eigen(A)

matrix(1:4, 2) # 2 rows implies 2 columns

# Building a matrix one element at time
y <- matrix(nrow = 2, ncol = 2)
y <- matrix(NA, 2, 2) # equivalent to previous line

y[1,1] <- 1
y[2,1] <- 2
y[1,2] <- 3
y[2,2] <- 4

# Filtering matrices
x <- matrix(c(1:3,2:4), 3,2)
x[x[,2] >= 3,] # true by default
# 1 isolates 2nd column
# 2 checks the condition on 2nd column's elements
# 3 acces to indices indicated by the boolean vector (recycling) x[booleanVector,]

m <- matrix(1:6, 3,2)
m[m[,1] > 1 & m[,2] > 5] # & of two boolean vectors (ftt & fft) = fft
# see ?"&"
which(m > 2)

# Applying functions to a matrix rows and columns (see ?apply)
m <- matrix(1:6, 3,2)
apply(m,2,mean) # equivalent to colMeans(). We can use a function created by us

# If the function to be applied returns a vector of k components, then
# the result of apply() will have k rows. You can use the matrix transpose function
# t() to change it if necessary
apply(m,1,function(x) x/2) # the result is a 2x3 matrix (that's how apply works)
# by row and we have 3 rows so a 3-element vector is returned
t(apply(m,1,function(x) x/2)) # use transpose if necessary
# if the function returns a scalar, the result will be a vector, not a matrix

# The arguments are  separated by commas
# apply(array, margin, function, args of the function)

# cbind() and rbind() revisited
z <- matrix(1:9, 3,3)
one <- rep(1,3)
rbind(one,z) # in 1st row
rbind(z,1) # in last row (with recycling)
rbind(z[1,], rbind(one, z[2:3,])) # inserting in 2nd row

z <- cbind(c(1,1), c(2,3)) # this creates a matrix (time compsuming)
# better create a large matrix at first
class(z)

z <- z[,2] # we end up only with the 2nd column

# Vector/matrices distinction
z <- matrix(1:4, 2)
length(z)
class(z)
attributes(z)
dim(z)
nrow(z)
ncol(z)

# Avoiding unintended dimension reduction
z <- matrix(1:9, 3)
r2 <- z[2] # extracts 2nd row
class(r2) # r is a vector!! not a 1x3 matrix...
r2 <- z[2,,drop = F] # to avoid the reduction

# "[" is a function!
z[2,3]
"["(z,2,3)

as.matrix(c(7,2,2)) # vector to matrix

# Naming matrix rows and columns
z <- matrix(1:4, 2,2)
colnames(z) <- c("a", "b")
rownames(z) <- c("x", "y")

z <- matrix(1:4, 2,2, dimnames = list(c("r1", "r2"), c("c1", "c2")))
