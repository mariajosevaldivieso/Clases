##########################################
## Class 02: Review and  Data Management
## Author: Esteban Lopez
## Course: Spatial Analytics 
## Program: Master in Business Analytics
## Institution: Universidad Adolfo Ibáñez
##########################################

#---- Part 1: Review  -------------------

#Estas son las cosas que me gustaría que les queden bien claras

### 1. Sintaxis básica

# Creación de Objetos

x<-NULL # crea un objeto en blanco, el cual puede ir guardando cosas
y<-c(TRUE,FALSE) # crando un objeto con dos elementos, con formato logico
as.numeric(y)

A<-1
year<-seq(2010, 2020, by= 0.5) 
tiktoc<-c("Que", "linda", "te ves", "limpiando", "Esperancita", 4)
class(tiktoc)


numeros_en_textos<- c('1','2','3')
as.numeric(numeros_en_textos)

m1<-matrix(1:4,2,2) # tiene dos dimensiones, fila y columnas
m1%*%t(m1) # multiplico la matriz m1 con su traspuesta
diag(m1) # diagonal de la matriz m1ç
solve(m1)

a1<-array(1:12,dim = c(2,2,3)) # array es un elemento de 3 dimensiones, filas columnas y profundidad. primr elementi es fila, columna y densidad en ese orden

d1<-data.frame(m1)
data("quakes") # promise
d1<-data.frame(quakes) # funcion que crea un objeto de dos dimensiones, la dif con una matriz es que se puede guardar numeros y textos

ls()
l1<-list(NumeroUno=A,years,tiktoc,m1)

# Manipulación de Objetos
ls() # lista los elementos que estan en el ambiente


A<-1L  # con la L obligo a que sea un entero

class(A) # funcion que permite el tipo de elemnto que hay
typeof(A) # los elemntos de que tipo son dentro del objeto (double es decimal)

length(years) # usarlo cuando el elemento tiene una dimension
dim(m1) # para objetos de dos dimensiones

object.size(d1) # ayuda a entender el tamaño del aobjeto que estoy creando

names(d1) # muestra los nombres de las variables
head(d1) # da las primeras 6 observaciones de la base de dato
tail(d1) # da los 6 ultimas lineas de observaciones de la base de dato

rm(l1) # elimina una varible

#Bonus: como se borra todo?

# Indexación uso de los []

length(years)
years[11]

dim(m1) # elemento de dos dimensiones, fila y columndas
m1[2,2] # me entrega el valor de la matriz en la fila dos, columnda 2

dim(a1)
a1[2,1,3] # posicion de la matriz, fila 2, columna 1, dimension 3

l1[2]
l1[2][[1]][1:2]

l1[[2]][1:2]

l1$NumeroUno


d1[1,] # me sale la primera fila y todas las columnas
d1[,1] # me sale todas las filas y la primera columna
d1[, 'lat']
d1$mag[seq(1,16,2)]

head(d1)

d1$lat[1:4]
d1[,'lat']
d1[1:4,c('lat','long')]


d1$mag>5
table(d1$mag>5)
d1[d1$mag>6,]
d1$dummy_5up<-as.numeric(d1$mag>5)
head(d1)

# Distinguir entre funciones, objetos, números y sintaxis básica
# Funciones: palabra + () con argumentos separados por commas
# Objetos: palabras a la izquierda del signo <- 


#---- Part 2: Loops  -------------------

A<-2
dim(A)

if(A==1){
  print("A es un objeto con un elemento numérico 1")
} else {
  print("A no es igual a 1, pero no se preocupe que lo hacemos")
  A<-1L
}


for(i in 1:5){
  print(paste("Me le declaro a la ", i))
  Sys.sleep(2)
  print("no mejor no... fail!")
  Sys.sleep(1)
}

i<-1
while(eps>0.001){
  eps<-50/(i^2)
  print(paste("eps value es still..", eps))
  i<-i+1
}

#---- Part 3: Data Management ----
# Tres formas de trabajar con datos

### 1. R-Base 
#http://github.com/rstudio/cheatsheets/raw/master/base-r.pdf

quakes[quakes$mag>6,'mag']

by(data = quakes$mag,INDICES = quakes$stations,FUN = mean)
tapply(X = quakes$mag,INDEX = quakes$stations, FUN = mean)

### 2. tydiverse 
#https://rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf
library(tidyverse)
#Cómo se instala el paquete si no lo tengo? Tank!!! ayudaaaa!

quakes %>% 
  filter(mag>6) %>% 
  select(mag) 

quakes %>% 
  group_by(stations) %>%
  summarise(mean(mag))


### 3. data.table (recommended in this course)
library(data.table)
#https://github.com/rstudio/cheatsheets/raw/master/datatable.pdf

quakes<-data.table(quakes)

quakes[mag>6,.(mag)]

quakes[,mean(mag),by=.(stations)]

### Reading data from a file

library(readxl)

casos<-data.table(read_excel("Class_02/2020-03-17-Casos-confirmados.xlsx",na = "—",trim_ws = TRUE,col_names = TRUE),stringsAsFactors = FALSE)

casos<-casos[Región=="Metropolitana",]

library(ggplot2)

ggplot(casos[order(Edad,decreasing = T)],)+geom_bar(stat = 'identity' ,aes(x=`Centro de salud`, y=Edad/Edad, group=Sexo, fill=Edad)) + coord_flip()+ facet_wrap(~Sexo) 

casos[Sexo=="Fememino",Sexo:="Femenino"]

ggplot(casos[order(Edad,decreasing = T),])+geom_bar(stat = 'identity',aes(x=`Centro de salud` ,y=Edad/Edad,fill=Edad)) + coord_flip()+ facet_wrap(~Sexo) +labs(title = "Casos Confirmados por Sexo y Establecimiento",subtitle = "Región Metropolitana - 2020-03-17",caption = "Fuente: https://www.minsal.cl/nuevo-coronavirus-2019-ncov/casos-confirmados-en-chile-covid-19/")

