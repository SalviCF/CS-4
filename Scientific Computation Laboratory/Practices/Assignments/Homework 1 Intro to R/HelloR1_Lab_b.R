#######################################################################

# Autor: Salvador Carrillo Fuentes
# Ejercicio: Hello woRld - I - LAB b - vectores

#######################################################################

cat("Ejercicios con vectores: HelloR1_Lab_b")

# Importamos el dataset (ya viene con R)
library(datasets)
data("UKgas")
View(UKgas)

# 0. Almacenar la columna del dataset en un vector llamado consumo.de.gas

consumo.de.gas <- UKgas

# 1. Obtener los índices del vector consumo.de.gas cuyos elementos son menores de 50

which(consumo.de.gas < 50) # todos son mayores
which(consumo.de.gas < 100) # test para que devuelva algo

# 2. Añadir (20,21,NA,22) al vector consumo.de.gas y guardarlo en consumo.de.gas1

consumo.de.gas1 <- c(consumo.de.gas,  c(20,21,NA,22))
View(consumo.de.gas1)

# 3. Obtener los índices del vector consumo.de.gas1 con valor NA.

which(is.na(consumo.de.gas1))
# which(consumo.de.gas1 == NA) doesn't work because consumo.de.gas1 == NA returns NA's

# 4. Calcular la media de los valores del vector consumo.de.gas1

media <- mean(consumo.de.gas1); media # el resultado es NA, no puede calcular la media (Not Available)
# si un valor no está disponible, no se podrá calcular la suma de ellos entre el número de valores...
media <- mean(consumo.de.gas1, na.rm = T) # remove NA's before mean computation

# it is not the same as change the NA's by 0
  # consumo.de.gas1[is.na(consumo.de.gas1)] <- 0
  # mean(consumo.de.gas1)


# 5. Calcular la media de aquellos valores del vector consumo.de.gas1 que estén por encima de la media

consumo.de.gas1.noNA <- consumo.de.gas1[!is.na(consumo.de.gas1)] # quito los NA
m <- mean(consumo.de.gas1.noNA) # Calculo la media
aboveM <- consumo.de.gas1.noNA[consumo.de.gas1.noNA > m] # calculo valores por encima de la media
m.aboveM <- mean(aboveM) # calculo la media de los valores por encima de la media

# In one line
mean(consumo.de.gas1[consumo.de.gas1 > mean(consumo.de.gas1, na.rm = T)], na.rm = T)

# Other solution for remove NA
# consumo.de.gas1[- which(is.na(consumo.de.gas1))] # solution 1
# as.logical(sum(consumo.de.gas1[!is.na(consumo.de.gas1)] == consumo.de.gas1[- which(is.na(consumo.de.gas1))]))

# Se puede conseguir de forma directa indicando que se desechen los NA antes de calcular
# Con ?mean, vemos un na.rm = argument, por defecto = FALSE. Lo ponemos a TRUE y desechamos NAs
m2 <- mean(consumo.de.gas1, na.rm = TRUE) # calculo la media
aboveM2 <- consumo.de.gas1[consumo.de.gas1 > m2]
m.aboveM2 <- mean(aboveM2, na.rm = TRUE)

# 6. Cambiar los valores NA del vector consumo.de.gas1 por 0
# https://stackoverflow.com/questions/8161836/how-do-i-replace-na-values-with-zeros-in-an-r-dataframe

consumo.de.gas1[is.na(consumo.de.gas1)] <- 0
# is.na es un vector de booleanos indicando si el elemento es NA o no
# accedo a los valores de consumo.de.gas1 marcados como TRUE (los NA) por el vector de booleanos
# cambio esos valores por 0

# También se puede hacer mediante índices
# comsumo.de.gas1[which(is.na(consumo.de.gas1))] <- 0
