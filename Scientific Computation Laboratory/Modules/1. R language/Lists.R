# Lists are vectors (recursive vectors, not atomic)

# Creating a list
alumn1 <- list(name = "Salvi",
               number.subjects = 3,
               name.subjects = c("LabCom", "PraExt", "ProLeg")
              )

# Visualizing the list
alumn2

# Creating without tags (note the names by default: result: [1] but inside the list: [[1]])
alumn2 <- list("Salvi",3,c("LabCom", "PraExt", "ProLeg"))

# Accesing the elements of a list
alumn1$name
alumn1$number.subjects
# names can be abreviated
alumn1$nu # because does not cause ambiguity
alumn1$name.subjects # acces the entire vector of subjects
alumn1$name.subjects[2] # acces only the second subject

# BE CAREFUL: if single brackets are used, the result is a list (a sublist of the original)
alumn1[1] # this returns a sublist
alumn1[[1]] # this returns the object itself
class(alumn1[1]) 
class(alumn1[[1]]) 
is.list(alumn1[1])
is.list(alumn1[[1]])

# unlist()...flattens a list and returns a vector
unlist(alumn1) # becomes a vector and coerces types
l <- list(list(1:3, 4), 5)
mean(l) # does not work
mean(unlist(l)) # now it works
unlist(l)

################################################

# List creation
worker <- list(name = "Salvi", salary = 5500, union = T)

# List indexing (three ways)
# Three ways to access an individual component c of a list lst and return it in the data type of c
worker$salary # use tab to autocomplete
worker$sa # there is no ambiguity
worker[["salary"]]
worker[[2]]

# If single brackets are used, the result is a list (a sublist of the original)
worker[1:2]
worker[-2] # also negative indices allowed (this returns a list)
worker[c("salary", "name")] # this also returns a list
worker2 <- worker[2]
class(worker2) # this is a list whose only element is a number, not a single number
str(worker2)

# In contrast...this returns the single object itself, not a sublist
class(worker[[2]])
str(worker[[2]])

# Adding and deleting list elements
z <- list(a = "abc", b = 12)
z
z$c <- "sailing" # adding a new component to the list via '$'
z
z[[4]] <- 28 # adding a new component via vector index
z
z[5:7] <- c(F,T,F) # no need to use double brackets to add, only to acces

z[6] <- NULL # deletes the component (the indices of the elements after it moved up by 1)
z$b <- NULL 

# Concatenation of lists
list1 <- list("Salvi", 1, T)
list2 <- list(T, c(1,2,3))
list3 <- c(list1, list2)

# Size of a list
length(list1)

# Accesing list components and values
names(worker) # to obtain the tags
unlist(worker) # to obtain the values (return type is a vector)
class(unlist(worker)) # uses coercion (structure precedence)
# For delete the names
names(worker) <- NULL
unname(worker) # this does not destroy the names
worker

# Applyying functions to lists
# lapply (list apply): see ?lapply (returns a list)
lapply(list(1:3,25:29),median) # applies median() to the two elements of the list
list(median(1:3), median(25:29)) # equivalent

# sapply (simplied [l] apply): the list returned is simplified to a vector or a matrix
sapply(list(1:3, 25:29), median)
unlist(lapply(list(1:3,25:29), median)) # equivalent

# Recursive lists: lists within lists
a <- list(x = 2, y = 4)
a[["x"]] # by name
b <- list(z = 3, w = 9)
q <- list(a,b) # each element is a list
q[[1]]$x # numeric class
q[[1]][1] # list class
q[[1]][["x"]] # numeric class
q[[1]][[1]] # numeric class

my.list <- list(sl1 = list(n1 = 6,n2 = 34), sl2 = list(h = "hello", b = "bye"))
my.list[[c("sl1", "n2")]]
my.list[[c(1,2)]]
my.list[[c(1,"n2")]] # ERROR: cannot mix

d <- list(list(10,20), list(30,40))
class(d[[1]]) # the first element of the outer list
class(d[1])

identical(d[[1]], d[1])
summary(d[[1]])
summary(d[1])
str(d[[1]]) # KEY
# d[[1]] is the first element of the outer list
str(d[1]) # this returns the element as a list
# d[1] is the first element of the outer list, but inside a list
# So, it returns a list (the element) inside a list (the wrapper)

d[[1]][1] # first element of the first element
d[[1]][[1]] # 
class(d[[1]][1]) # single number list
class(d[[1]][[1]]) # single number

# See ?c
# Es raro que recursive = T de una lista no recursiva...
c(list(a=1,b=2,c=list(d=5,e=9)))
c(list(a=1,b=2,c=list(d=5,e=9)), recursive = T) # to flatten a list
str(c(list(a=1,b=2,c=list(d=5,e=9))))

# Returns a vector, not a list
class(c(list(a=1,b=2,c=list(d=5,e=9)), recursive = T))
class(c(a=1,b=2,c=3,d=4))
is.vector(c(list(a=1,b=2,c=list(d=5,e=9)), recursive = T))

# Storing any kind of objects
another.list <- list(month.abb,  matrix(c(5,8,1,-4), nrow = 2), sin, diag(3))
names(another.list) <- c("months", "matrix1", "function", "matrix2")

# Recursive or atomic
is.recursive(list()) # lists are recursive
is.atomic(list())
is.recursive(c())
is.atomic(c())

NROW(list(1,2,3))
NCOL(list(1,2,3))
NROW(c(1,2,3))
NCOL(c(1,2,3))

l1 <- list(1:5)
l2 <- list(1:5)
l1[[1]] + l2[[1]]

# Vector to list
v <- 1:5
l <- as.list(v) 
as.numeric(l) # if all elements of l are scalars

l <- list(one=1, two=2, three=3, four=c(2,2), five=5, six=c(2,3))
unlist(l)





