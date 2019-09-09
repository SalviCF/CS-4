2+4

# Para asignar puedo usar '<-' o '='
x <- y <- 12 # x = y = 12
# shortcut: Alt - para obtener <-

# Para limpiar pantalla Ctrl L

# Para depurar rápidamente (aunque tiene un depurador más complejo): browser()

a <- 3*pi

# Puedo ejecutar línea a línea con ctrl enter o todo el código con botón Source

# Definir una función
area.rect <- function(largo, ancho){
    area <- largo * ancho
} # end function

# Si lo pongo entre paréntesis me saca el resultado (area.rect(3,6))

mi.area <- area.rect(3,6)

# tipos de datos (atómicos)
# jerarquía : character, double, numeric, logical (hace la conversión al más fuerte)

miString <- "Salvi"
n1 <- 45
# no es exactamente lo mismo la clase que le tipo class() y typeof()
# si quiero que mi número sea entero tengo que ponerle 'L' detrás

log1 <- TRUE

# shortcuts: cursor to console: ctrl + 2, cursor to source: ctrl + 1
# https://support.rstudio.com/hc/en-us/articles/200711853-keyboard-shortcuts

# NA = Not Available
class(NA)

# testeo de tipos
is.atomic(log1)

# conversión de tipos
as.integer(log1)
class(as.integer(log1))

0/0 # Not A Number

-3/0 < 6

# Vectores
miVcetor <- c(1,2,3)
miVector2 <- 1:10

v <- c(1,2,"hola")
sum(c(1,2,3,FALSE))

# Un vector es una colección de elementos del mismo tipo (unidimensional)
v <- c(1,2, c(3,4,5)) # lo aplana
v2 <- c() # vector vacío

# operaciones para los vectores
v2 <- cos(v)

# Reciclaje
v1 <- 1:10
v2 <- 2:3
v1 + v2

# los vectores empiezan por la posición 1
# sacar elementos pares del vector
v1[c(FALSE,TRUE)]

mean(1:10)
# help mean

# para poner nombres a los elementos
v1 <- 1:4
n1 <- c("c1", "c2", "c3", "c4")

names(v1) <- n1
v1

v1[c(1,3,2,2)]
v1[-c(1,2)]

# listas: elementos de distinto tipo y distinta dimensión (todo está hecho con listas)
miLista <- list(1, 2, "Salvi", c(5,6,7))
str(miLista)
str(v1)

# Subsetting
miLista[[3]] # me meto en la lista y luego examino el elemento
# si tenemos dudas, usar class o str

# unlist aplana la lista
unlist(miLista2)

# matrices (se almacenan por columnas)
miMatriz <- matrix(1:16)
miMatriz <- matrix(1:16, nrow = 4, byrow = TRUE)
miMatriz
dim(miMatriz)
class(miMatriz)
is.list(miMatriz)

# Cambiar de vector a matriz (otra forma de meter matriz en memoria)
v1 <- 1:16
dim(v1) = c(4,4)
v1

miMatriz[1,]
miMatriz[,1]
miMatriz[c(1,3),]

# Para borrar las variables del entorno
remove(list = ls())
rm(list = ls())

v <- 1:10
names(v) <- paste("n", v)

# For alternativa para construir matrices
v <- 1:12
dim(v) <- c(3,4)
v[1,3]






