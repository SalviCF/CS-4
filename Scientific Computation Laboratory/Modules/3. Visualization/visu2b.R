#geom bar
housing <- read_csv("landdata-states.csv")

housing.sum <- aggregate(housing["Home.Value"], housing["State"], FUN=mean)
rbind(head(housing.sum), tail(housing.sum))
ggplot(housing.sum, aes(x=State, y=Home.Value)) + geom_bar()
# Usar stat="identity"
# Las alturas de las barras representan valores en los datos.

ggplot(housing.sum, aes(x=State, y=Home.Value)) + geom_bar(stat="identity")

library(gcookbook)
View(BOD)
ggplot(BOD, aes(x=Time, y=demand)) + geom_line()
ggplot(BOD, aes(x=factor(Time), y=demand)) + geom_line()
#geom_path: Each group consists of only one observation. 
ggplot(BOD, aes(x=factor(Time), y=demand,group=1)) + geom_line()

# Expandir eje Y
ggplot(BOD, aes(x=Time, y=demand)) + geom_line() + ylim(0, max(BOD$demand)+5)
ggplot(BOD, aes(x=Time, y=demand)) + geom_line() + expand_limits(y=0)

#geom line, geom point
# Cambiar a escala logarítmica
x=1:100
y=exp(x)
D <- data.frame(x,y)
ggplot(D,aes(x=x,y=y))+geom_line()
ggplot(D,aes(x=x,y=y))+geom_line()+scale_y_log10()

# Añadir puntos a una línea
ggplot(BOD, aes(x=Time, y=demand)) + geom_line() + geom_point()

# Cambiar apariencias de líneas y de punto
ggplot(BOD, aes(x=Time, y=demand)) +
  geom_line(linetype="dashed", size=1, colour="blue") +
  geom_point(size=4, shape=22, colour="darkred", fill="pink")
ggplot(BOD, aes(x=Time, y=demand)) +
  geom_line() + geom_point(size=4, shape=21, fill="white")

# Añadir elementos a un gráfico
g1 <- ggplot(BOD, aes(x=Time, y=demand)) + geom_area() 
g1 + geom_area(colour="black", fill="blue", alpha=.5)

#Añadir etiquetas
cabbage_exp
ggplot(cabbage_exp, aes(x=interaction(Date, Cultivar), y=Weight)) +
  geom_bar(stat="identity") +
  geom_text(aes(label=Weight), vjust=2.5, colour="red")
# Ayuda: ?interaction
# Repetir con vjust=-0.2

# Temas de un gráfico
housing <- read_csv("landdata-states.csv")

housing.sum <- aggregate(housing["Home.Value"], housing["State"], FUN=mean)
ggplot(housing.sum, aes(x=State, y=Home.Value)) +  geom_bar(stat="identity")
p3 <- ggplot(housing, aes(x = State,  y = Home.Price.Index)) +
  theme(legend.position="top", axis.text=element_text(size = 6))
p3
p4 <- p3 + geom_point(aes(color = Date),  alpha = 0.5, size = 1.5,
                      position = position_jitter(width = 0.25, height = 0))
p4 + scale_x_discrete(name="State Abbreviation") +
  scale_color_continuous(name="Dates", breaks = c(1976, 1994, 2013),
                         labels = c("’76", "’94", "’13"),  low = "blue", high = "red")
p4 + scale_color_gradient2(name="Dates", breaks = c(1976, 1994, 2013),
                           labels = c("’76", "’94", "’13"), 
                           low = muted("blue"),
                           high = muted("red"), 
                           mid = "gray60", midpoint = 1994)
# Escribir scale_  y pulsar tabulador para ver posibles opciones

DF1 <- data.frame(x = 1:10, y = 1:10, gp = factor(rep(1:2, each = 5)))
p0 <- ggplot(DF1, aes(x = x, y = y, colour = gp)) + geom_point() +
  labs(x = "State", y = "Home.Value", colour = "Cylinders")
p0 +
  ggtitle("New Theme")+
  theme_bw() +
  theme(axis.text = element_text(size = 14),
        legend.key = element_rect(fill = "navy"),
        legend.background = element_rect(fill = "white"),
        legend.position = "top",
        panel.grid.major = element_line(colour = "grey40"),
        panel.grid.minor = element_blank(),
        axis.line = element_line(colour = "blue", size = 2),
        axis.line.y = element_line(colour = "orange", linetype = "dashed"),
        axis.ticks = element_line(colour = "purple", size = 0.5),
        axis.ticks.length = unit(0.25, "cm"),
        axis.title = element_text(size = 20, color = "maroon"),
        axis.title.y = element_text(vjust = 1, angle = 30, face = "bold"),
  ) 

# Temas de un gráfico
# panel.grid.major.x = element_blank()
# panel.grid.minor.x = element_blank()
theme_set(theme_grey())
tt <- theme(axis.text = element_text(size=14, colour=NULL))
qplot(1:3, 1:3) + tt
themeMod <- theme_grey() +
  theme(text = element_text(family = "Times", colour = "blue", size = 14))
qplot(1:3, 1:3) + themeMod

housing <- read_csv("landdata-states.csv")
p5 <- ggplot(housing, aes(x = Date, y = Home.Value)) 
p5 + geom_line(aes(color = State))

# Comando facet
p5 <- p5 + geom_line() + facet_wrap(~State, ncol = 10)
p5 + theme_linedraw()
p5 + theme_light()
p5 + theme_minimal() + theme(text = element_text(color = "turquoise"))
