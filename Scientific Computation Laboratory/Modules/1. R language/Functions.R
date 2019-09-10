# Functions #

adder <- function(x = 10,y = 20) x + y # by default parameters
adder() 
adder(2,5)

double <- function(x) return(x * 2) 

# Functional programming
superAdder <- function(x) return(function(y) x + y)
f <- superAdder(5)
f(3)

my.mean <- function(v) sum(v)/length(v)

##############################################################################

# Logical comparison #

v1 <- 1:10
v1 > 5
all(v1 > 5)
any( v1 > 5)
