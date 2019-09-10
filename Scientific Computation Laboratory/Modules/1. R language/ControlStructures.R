# Control structures #

# If #

a <- -3
b <- 5

if (a > b | a < 0)
  a+b

if (a < b) a*b

################################################################################

# If-else #

if (a > b | a < 0){
  print("Condition True")
  a+b
}#endif

if (a > b | a > 0){
  print("Condition True")
  a+b
} else {
  print("Condition False")
  a-b
}#end

if (a < b){
  cat("a = ",a,", b = ",b,"\nAddition\n")
  a+b
} else if (a == b){
  cat("a = ",a,", b = ",b,"\nMultiplication\n")
  a*b
} else {
  cat("a = ",a,", b = ",b,"\nSubstraction\n")
  a-b
}#end

################################################################################

# For loop #

for (i in 1:5) {
  print(i)
}#endfor

for (i in 1:5) cat(i," ")

x <- c("one","two","three","four","five")
for (i in 1:length(x)) print(x[i])

for (i in seq_len(5)) print(i)

for (i in seq_along(x)) print(x[i])

for (i in seq_along(x)) print(x[i])

# Print matrix by rows
x <- matrix(1:6, 2,3)
for (i in seq_len(nrow(x))){
  for (j in seq_len(ncol(x))){
    print(x[i,j])
  }
}

################################################################################

# While loop #

k <- 0
while (k <= 10) {
  print(k)
  k <- k + 1
}#endwhile

################################################################################

# Repeat loop #

k <- 0
repeat {
  print(k)
  k <- k + 1
  if (k == 10) break
}#endrepeat
