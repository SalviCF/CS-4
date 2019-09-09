# Autor: Salvador Carrillo Fuentes
# Descripción: Ejercicio individual

#####################################################################################################

# Errores comunes - Ejercicio 3.1 #

# Explica por qué los siguientes comandos dan error o no hacen lo que podría ser previsible 
# con la lectura del comando. Arréglalo.

library(datasets)
data("mtcars")

# 1.
# Comando original: 
  mtcars[mtcars$cyl = 4, ]
# Error: la comparación debe hacerse con el "=="
# Comando correcto:
  mtcars[mtcars$cyl == 4, ] 

# 2. 
# Comando original
  mtcars[-1:4, ]  
# Error: No está permitido mezclar índices positivos y negativos
# Comando correcto:
  mtcars[c(1:4)[-1], ]

# 3.
# Comando original
  mtcars[mtcars$cyl<=5]
# Error: Falta la coma para especificar las columnas consideradas
# Comando correcto:
  mtcars[mtcars$cyl<=5, ]

# 4.
# Comando original
  mtcars[mtcars$cyl==4|6, ]
# Error: la sintaxis del OR lógico no es la correcta
# Comando correcto:
  mtcars[mtcars$cyl==4 | mtcars$cyl==6, ]

# 5.
# Comando original
  mtcars[1:20]
# Error: falta la coma para indicar las columnas
# Comando correcto:
  mtcars[1:20, ]

# 6.
# Comando original
  x <- 1:5; x[NA]
# Error: hay que usar is.na junto con which para obtener los índices de los valores NA
# Comando correcto:
  x <- 1:5; which(is.na(x))
  
#####################################################################################################

# Vectores y Listas - - Ejercicio 3.2 
# Implementa una función que reciba una matriz M y devuelva la diagonal de la matriz (D), 
# la submatriz inferior debajo de la diagonal (L) y 
# la submatriz superior encima de la diagonal (U)
  
divido.matriz <- function(M){
  D <- U <- L <- M
  L[!row(M) > col(M)] <- 0
  U[!row(M) < col(M)] <- 0
  D[!row(M) == col(M)] <- 0
  return(list(diagonal=D,upper=U,lower=L))
}

# Ejemplo
M <- matrix(1:9,3,3) 

# (CTRL+SHIFT+C to comment multiple lines)

# > M
# [,1] [,2] [,3]
# [1,]    1    4    7
# [2,]    2    5    8
# [3,]    3    6    9
# > divido.matriz(M)
# $diagonal
# [,1] [,2] [,3]
# [1,]    1    0    0
# [2,]    0    5    0
# [3,]    0    0    9
# 
# $upper
# [,1] [,2] [,3]
# [1,]    0    4    7
# [2,]    0    0    8
# [3,]    0    0    0
# 
# $lower
# [,1] [,2] [,3]
# [1,]    0    0    0
# [2,]    2    0    0
# [3,]    3    6    0
  
#####################################################################################################

# Vectores y Listas - - Ejercicio 3.3 #

# Dado una pareja de vectores mu y nu, realizar una función que haga lo siguiente:
# Vaya cogiendo los elementos de mu y nu que estén en la misma posición y los reuna en 
# vectores. Todas las parejas se reunirán en una lista y está es la salida de la función. 

iset <- function(mu,nu){
  m <- rbind(mu,nu)
  split(m,col(m))
}#end function

mu <-c(0.1, 0.3, 1)
nu <-c(0.7,0.5,0)

# Ejemplo
# > mu
# [1] 0.1 0.3 1.0
# > nu
# [1] 0.7 0.5 0.0
# > memb <- iset(mu,nu)
# > str(memb)
# List of 3
# $ 1: num [1:2] 0.1 0.7
# $ 2: num [1:2] 0.3 0.5
# $ 3: num [1:2] 1 0




