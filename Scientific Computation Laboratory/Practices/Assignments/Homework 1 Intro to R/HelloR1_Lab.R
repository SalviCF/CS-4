#######################################################################

# Autor: Salvador Carrillo Fuentes
# Ejercicio: Hello woRld - I - LAB - vectores

#######################################################################

cat("Ejercicios con vectores: HelloR1_Lab") # Para imprimir

# Importamos el dataset (ya viene con R)
library(datasets) # para cargar el paquete datasets
data("UKgas") # carga el dataset UKgas
View(UKgas) # para visualizar el dataset UKgas

# to list currently loaded packages
(.packages())

# 0. Almacenar la columna del dataset en un vector llamado consumo.de.gas
consumo.de.gas <- UKgas

# 1. Acceder a los 10 primeros elementos del vector consumo.de.gas
consumo.de.gas[1:10]

# 2. Acceder a los elementos impares del vector consumo.de.gas
# http://adv-r.had.co.nz/Subsetting.html
# If the logical vector is shorter than the vector being subsetted, 
# it will be recycled to be the same length
consumo.de.gas[c(TRUE,FALSE)] # uso reciclaje
# consumo.de.gas[seq(1,length(consumo.de.gas),2)] # menos elegante

# 3. Acceder a las posiciones 1,4,7,10,. del vector consumo.de.gas
consumo.de.gas[c(TRUE,FALSE,FALSE)] # uso reciclaje
# consumo.de.gas[seq(1,length(consumo.de.gas),3)] # menos elegante

# 4. Acceder al vector consumo.de.gas en orden inverso
consumo.de.gas[length(consumo.de.gas):1] # Solution 1
rev(consumo.de.gas) # Solution 2

# 5. Acceder a los 50 primeros elementos del vector consumo.de.gas excepto la posición 1, 3 y 5.
consumo.de.gas[(1:50)[-c(1, 3, 5)]] # Solution 1
consumo.de.gas[1:50][-c(1,3,5)] # Solution 2
# c(1:10)[c(-1,-3)] equivale a c(1:10)[-c(1,3)]
# En 2 pasos:
  # aux <- consumo.de.gas[1:50] # cojo los 50 primeros
  # aux[-c(1,3,5)] # quito las posiciones 1, 3 y 5

# 6. Sumarle 1 a los elementos del vector consumo.de.gas (reciclaje)
# Reciclaje: c(1,2,3) + 1 equivale a c(1,1,1) + c(1,1,1)
# The number 1 is recycled as a vector that matches the size of v
consumo.de.gas + 1
# consumo.de.gas + c(1)
