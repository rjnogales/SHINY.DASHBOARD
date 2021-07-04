#####################################
## Versión 01
## 01tdDemandaGlobal.R
## Función:
## Organiza  la presentación
## shiny de la demanda
## Esto es código Global
#####################################

#####################################
# LIBRERIAS
#####################################

# Las toma de demandaEjecuta

#####################################
## ESTRUCTURA DE BOTONES & COMANDOS
## CODIGO CORRESPONDIENTE
#####################################

# shinyWidgetsGallery()

# ## TIPO DE DATOS: USOS & INTEGRA
# ## TIPO DE GRAFICA: AÑO . MES : MES . AÑO
# ## TIPOLOGIA
# prettyRadioButtons(
#   inputId = "Id039",
#   label = "Choose:", 
#   choices = c("Click me !", "Me !", "Or me !"),
#   icon = icon("check"), 
#   bigger = TRUE,
#   status = "info",
#   animation = "jelly"
# )

# 
# ## AÑOS & MESES
# pickerInput(
# inputId = "Id081",
# label = "Default", 
# choices = c("a", "b", "c", "d")
# )
# 
# ## BOTONES: DATOS & GRAFICAS
# actionBttn(
#   inputId = "Id103",
#   label = NULL,
#   style = "material-circle", 
#   color = "danger",
#   icon = icon("bars")
# )

#####################################
## FUNCIONES
#####################################

## COLOCA MULTIPLICADOR EN LETRAS 
## K: 1000 
ks <- function (x) { number_format(accuracy = 0.01,
                                   scale = 1/1000,
                                   suffix = "M",
                                   big.mark = ",")(x) }

## M: UN MILLON
ms <- function (x) { number_format(accuracy = 0.01,
                                   scale = 1/1000000,
                                   suffix = "M",
                                   big.mark = ",")(x) }

## G: 1000 MILLONES
gs <- function (x) { number_format(accuracy = 0.01,
                                   scale = 1/1000000000,
                                   suffix = "M",
                                   big.mark = ",")(x) }

#####################################
# VARIABLES
#####################################

# meses_lista <-c("Enero","Febrero","Marzo","Abril","Mayo","Junio",
#   "Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre")

## INFORMACION LECTURA DE DATOS

## carpeta del directorio donde se encuentran los datos & proyecto
## LINUX
carpetaProyecto <- "/home/rjnogales/Dropbox/10.DRIVE/R.SHINY/data/"

# prefijo del nombre del archivo correspondiente
# al mes: dmes+año+mes
prefijoData <- "dmes"

## LISTA DE ARCHIVOS
pathData       <- carpetaProyecto
archivos_lista <- dir(pathData)

## LISTA DE AÑOS + MESES 
listaMeses     <- archivos_lista
listaMeses     <- str_sort(substr(listaMeses,5,11),decreasing = TRUE)

## VARIABLES DE LOS DATOS
## FILTROS.INFRAESTRUCTURA

listaEstacion <- c("A01A","A02","A03",
                   "A04","A05","A06",
                   "A12A","A12B","A12C",
                   "A12D","A13A","A13C",
                   "A14A","A14B","A17B",
                   "A17C","A17D","A17E",
                   "A18","A19A","A19B",
                   "A21","A22","A23",
                   "A32","A33","A35A",
                   "A36","A37A","A37B",
                   "A41A","A41C","A44A",
                   "A44B","A46","A47",
                   "A57","A70","A71",
                   "A72A","A72B","A73",
                   "A75","A76","A77",
                   "A78A","A81","A99",
                   "E27","ESTACION 7 AGOSTO","ESTACION ALAMOS",
                   "ESTACION AMANECER","ESTACION AMERICAS","ESTACION ATANASIO",
                   "ESTACION BELALCAZAR","ESTACION BRISAS","ESTACION BUITRERA",
                   "ESTACION CABLE CANAVERAL","ESTACION CALDAS","ESTACION CALIPSO",
                   "ESTACION CANAVERALEJO","ESTACION CAPRI","ESTACION CENTRO",
                   "ESTACION CHAPINERO","ESTACION CHIMINANGOS","ESTACION CIEN PALOS",
                   "ESTACION CONQUISTADORES","ESTACION ERMITA","ESTACION ESTADIO",
                   "ESTACION FATIMA","ESTACION FLORA INDUSTRIAL","ESTACION FLORESTA",
                   "ESTACION FRAY DAMIAN","ESTACION LIDO","ESTACION LLERAS",
                   "ESTACION MANZANA DEL SABER","ESTACION MANZANARES","ESTACION MELENDEZ",
                   "ESTACION NUEVO LATIR","ESTACION PAMPALINDA","ESTACION PETECUY",
                   "ESTACION PILOTO","ESTACION PLAZA CAICEDO","ESTACION PLAZA DE TOROS",
                   "ESTACION POPULAR","ESTACION PRADOS DEL NORTE","ESTACION PRIMITIVO",
                   "ESTACION REFUGIO","ESTACION RIO CALI","ESTACION SALOMIA",
                   "ESTACION SAN BOSCO","ESTACION SAN PASCUAL","ESTACION SAN PEDRO",
                   "ESTACION SANTA LIBRADA","ESTACION SANTA MONICA","ESTACION SUCRE",
                   "ESTACION TBLANCA","ESTACION TEQUENDAMA","ESTACION TORRE DE CALI",
                   "ESTACION TREBOL","ESTACION TRONCAL UNIDA","ESTACION UNIDAD DEPORTIVA",
                   "ESTACION UNIVERSIDADES","ESTACION VERSALLES","ESTACION VILLA NUEVA",
                   "ESTACION VILLACOLOMBIA","ESTACION VIPASA","P10A",
                   "P10B","P10D","P12A",
                   "P21A","P21B","P24A",
                   "P24B","P27C","P27D",
                   "P30A","P40A","P40B",
                   "P47A","P47B","P47C",
                   "P52D","P82","P84B",
                   "T40","T42","T47B - PADRONES",
                   "T50","T57A","TERMINAL ANDRES SANIN",
                   "TERMINAL MENGA","TERMINAL PASO DEL COMERCIO","U22"
)

listaSemana    <- c(1:54)

listaTServicio <- c("A","E","P","T","U")

listaTBus      <- c(0,2,3,4,5)

listaTDia      <- c("FES","HAB","SAB")

#####################################
# CODIGO
#####################################




