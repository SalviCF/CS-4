#######################################################################

# Autor: Salvador Carrillo Fuentes
# Ejercicio: Ejercicios diapositiva 9 del pdf Introducción a R - II

#######################################################################

# 1.
# Programar una función que devuelva dado un vector cuantos números
# impares tiene. AYUDA: Usar % % para calcular el resto

impares <- function(v){
  return(length(v[v%%2 != 0])) # me devuelve un vector con los elementos impares y calculo la longitud
}

# 2.
# Programar una función que calcule el volumen de una esfera (4pir^3)/3 dado el
# radio r de dicha esfera.

volumenEsfera <- function(r){
  return((4*pi*r^3)/3)
}

# 3.
# Programar una función que calcule el volumen de esferas con radio
# r = 1, 2, . . . , 20 y devuelva un data.frame con las dos columnas (radio, volumen).

volumenEsferas <- function(radios){
  df = data.frame(radio = radios, volumen = volumenEsfera(radios))
  return(df)
}
