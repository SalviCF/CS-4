# Factors (see ?factor) 
# Nominal(categorical) variables (e.g. blue, green)
# Ordered categorical (ordinal) (e.g. small, large)
# Nominal and ordinal variables are called factors in R
v <- c(1,1,2,8,5,3,8)
f <- factor(v) # unique values (ordered)
f

# Example
diabetes <- c("type1", "type1", "type2", "type1")
status <- c("poor", "improved", "excellent", "poor")
diabetes <- factor(diabetes) # stored as 1 1 2 1 (coded)
status <- factor(status,ordered = T) # alphabetical order
status <- factor(status, ordered = T, levels = c("poor", "improved", "excellent")) # to override default ordering
diabetes; status
str(diabetes)
unclass(diabetes) # how it's coded by level
summary(diabetes)
str(status)
summary(status)

sex <- c(1,1,1,2,1,2,2,1,2,1)
sex <- factor(sex, levels = c(1,2), labels = c("Male", "Female"))
sex
str(sex)
summary(sex)

diabetes <- factor(c("type1", "type2", "type1"), levels = c("type1", "type2", "type¿?"))

# Functions used with factors

# tapply() (see ?tapply)
# mean age in each group (R, D, U)
ages <- c(25,26,55,37,21,42)
affils <- c("R","D","D","R","U","D")
tapply(ages,affils,mean)

# split(): yields a list
split(ages, affils) # forming the groups by levels
