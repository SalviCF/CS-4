# Para devolver más de un resultado lo hago como lista

myFunction <- function(a,b){
  a1 <- a+b
  a2 <- a-b
  return(list(suma=a1, resta=a2)) # si no pongo return se devuelve el último resultado
}

# Ejercicios diapositiva 9 pdf Introducción a R 2

# Programar una función que devuelva dado un vector cuantos números
# impares tiene. AYUDA: Usar % % para calcular el resto

impares <- function(v){
  return(length(v[v%%2 != 0])) # me devuelve un vector con los elementos impares y calculo la longitud
}

# Programar una función que calcule el volumen de una esfera (4pir^3)/3 dado el
# radio r de dicha esfera.

volumenEsfera <- function(r){
  return((4*pi*r^3)/3)
}

# Para devolver data frames

returnDataFrame <- function(x,y){
  df <- data.frame(x,y)
  return(df)
}

# Programar una función que calcule el volumen de esferas con radio
# r = 1, 2, . . . , 20 y devuelva un data.frame con las dos columnas (radio, volumen).

volumenEsferas <- function(radios){
  df = data.frame(radio = radios, volumen = volumenEsfera(radios))
  return(df)
}

# Debemos usar seq_along en los bucles for (no length)
for(k in seq_along(1:10))
  print(k)

# Programación funcional (apply)
Notas <- list(alumno1=c(2.5, 3.7, 6), alumno2=c(5, 6.7, 10))
medias <- lapply(Notas, mean)

# sapply

data("airquality")
View(airquality)
sapply(airquality, mean)

# Usamos funciones anónimas (quitamos los NA)

sapply(airquality, function(x) mean(x, na.rm = TRUE))
sapply(airquality, mean, na.rm = T) # without anonymous function
# Deberes
# ignore NA del data frame 
s <- split(airquality, airquality$Month)
lapply(s, function(x) mean(x, na.rm = TRUE))


