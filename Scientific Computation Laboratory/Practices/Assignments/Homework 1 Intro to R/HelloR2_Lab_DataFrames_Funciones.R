#######################################################################

# Autor: Salvador Carrillo Fuentes
# Ejercicio: Hello woRld - II - LAB - Data Frames - Funciones

#######################################################################

#####################################################################################################

# Importamos el dataset states.csv mediante File -> Import Dataset -> From text(readr)
# En el histórico de comandos aparece la orden que se usó (To Console):
# library(readr)
# states <- read_csv("~/Grado Ingeniería Informática/G.I.I_2018/Segundo_cuatri/LabComp/Programas/Ejercicios.Casa/Ej.3/states.csv")
# View(states)

#####################################################################################################

# Manipular Data Frames - Ejercicio 2.1 #

# 1. Si el dataset importado no es un dataframe convertirlo a dataframe

is.data.frame(states) # ya es un data frame...

# 2. Analizar la estructura del dataset, tipo de datos, estructura, clase, etc
str(states) 
typeof(states) 
class(states) 
attributes(states)
summary(states)

# 3. Obtener número de columnas, número de filas
ncol(states)
nrow(states)

# Otra solución
filas <- dim(states)[1]
cols <- dim(states)[2]
dim(states) # me devuelve (# filas, # columnas)

# 4. Guardar en un vector el nombre de las columnas
names.cols <- names(states)

# 5. Cambiar el nombre de la segunda columna
names.cols[2] <- "zona"

# 6. Averiguar el tipo de datos de cada columna
sapply(states, typeof)

# 7. Extraer las 10 primeras filas y 3 primeras columnas y guardarlo en un data.frame
df <- states[1:10,1:3]

# 8. Extraer las 10 últimas filas y 3 últimas columnas y guardarlo en un data.frame
df2 <- tail(states,10)[,-c(1:(ncol(states)-3))]

# 9. Guardar las 10 primeras filas en una variable df1 y las 10 últimas en una variable df2
#    y combinarlas en un nuevo dataframe llamado df12
df1 <- head(states,10) # 10 primeras filas
df2 <- tail(states,10) # 10 últimas filas
df12 <- rbind(df1,df2)

#  10. Añadir una variable nueva al dataframe denomida "km" calculada a partirde la variable miles
states$km <- states$miles * 1.60934

# 11. Usar subset para guardar en una variable las filas de dataset con valor para region de West
region.west <- subset(states,states$region=="West")

# 12. Usar subset para guardar en una variable las filas de dataset con valor para region 
# de West y miles mayor que 8000
region.west <- subset(states,(states$region=="West") & (states$miles>8000))

# 13. Guardar la segunda columna en variable c1 y utilizar los comandos unique,table. 
# ¿Para qué sirven estos comandos?

c1 <- states[2]
?unique # quita elementos repetidos
unique(c1)
?table # construye una tabla de contingencia (frecuencia,factores)
table(c1)

# 14. Guardar la tercera columna en variable c2 y utilizar colSums,colMeans. 
# Explicar con ejemplos para qué sirven estos comandos
c2 <- states[3]
?colSums # calcula la suma de cada columna (el data frame debe ser numérico)
?colMeans # calcula la media de cada columna (el data frame debe ser numérico)

numeric.states <- states[sapply(states, is.numeric)] # obtengo las columnas númericas del dataframe
colSums(numeric.states, na.rm = T)
colMeans(numeric.states, na.rm = T)

# 15. Guarda el dataframe en una variable df2. En df2 elimina las columnas no numéricas. 
# Usa en este nuevo dataframe las funciones rowSums,rowMeans (explica lo que hacen)
df2 <- states[sapply(states, is.numeric)]
rowSums(df2, na.rm = T) # sumatorio por filas
rowMeans(df2, na.rm = T) # media por filas

# 16. Usar el comando order para ordenar las filas del dataframe states 
# según el valor decreciente de la columna density
?order
# returns the indices of a sorted vector with respect to the original vector
x <- c(6,2,5,8,1)
order(x)

# Podemos usar esos índices para sacar el orden
indices <- order(states$density, decreasing = T)
states[indices, ]

#####################################################################################################

# Funciones - Ejercicio 2.2 #

# 1. Escribir una función que reciba una columna del dataset original y averigue si hay valores NA. 
# Devuelve:
  # TRUE si los hay y FALSE si no los hay
  # Las posiciones de la columna en las que están los valores NA
hay.na.columna <- function(columna){
  na <- any(is.na(columna))
  positions <- which(is.na(columna))
  list(na,positions)
}

hay.na.columna(states$green)
hay.na.columna(states$csat)

# 2. Escribir una función que reciba el dataset original y averigue si hay valores NA. 
# Devuelve:
  # TRUE si los hay y FALSE si no los hay 
  # Las posiciones del dataframe en las que están los valores NA

hay.na.dataset <- function(dataset){
  na <- any(is.na(dataset))
  positions <- which(is.na(dataset))
  list(na,positions)
}

hay.na.dataset(states)
