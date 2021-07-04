#########################################
## CODIGO DE GRAFICA 
##
## TOTAL DE USOS POR SEMANA 
## VARIABLES: x:SEMANA, y:USO ACUMULADO: TIPO.SERVICIO, TIPO.BUS, TIPO.DIA
## 
#########################################

#########################################
## LIBRERIAS
#########################################
library(stringr)
library(lubridate)
library(data.table)
library(ggplot2)
library(scales)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(dplyr,warn.conflicts = FALSE)
library(tidyverse)
library(DT,warn.conflicts = FALSE)
library(formattable,warn.conflicts = FALSE)
# library(patchwork)
library(tictoc)

#########################################
## DATA
#########################################

## WINDOWS
# mesesf <- c(
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2019.01.Rds",
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2019.02.Rds",
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2020.01.Rds",
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2020.02.Rds",
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2021.01.Rds",
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2021.02.Rds"
# )
# 
# mesesf <- c(
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2020.01.Rds",
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2020.02.Rds",
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2021.01.Rds",
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2021.02.Rds"
# )
# 
# mesesf <- c(
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2021.01.Rds",
#   "C:/Users/rnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2021.02.Rds"
# )

## LINUX
mesesf <- c("/home/rjnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2021.03.Rds",
            "/home/rjnogales/Dropbox/10.DRIVE/R.SHINY/data/dmes2021.04.Rds")

## LECTURA DE DATOS
data <- mesesf %>%
  map_dfr(readRDS)

#########################################
## FILTROS
#########################################

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
# listaEstacion <- c("A01A","A02","A03",
#                    # "A04","A05","A06","P10A",
#                    "ESTACION VILLACOLOMBIA","ESTACION VIPASA"
# )

# listaEstacion <- c("ESTACION ESTADIO",
#                    "ESTACION UNIVERSIDADES")

listaSemana    <- c(1:54)
listaSemana    <- c(7:14)

listaTServicio <- c("A","E","P","T","U")
# listaTServicio <- c("A","E","P")

listaTBus      <- c(0,2,3,4,5)
# listaTBus      <- c(0,2,3)



listaTDia      <- c("FES","HAB","SAB")
# listaTDia      <- c("FES","HAB")


#########################################
## TABLAS DE DATOS
#########################################

## FILTROS & AGRUPAMIENTO
tic("filtros")
udata <- data %>%
  
  # SE QUEDAN LOS USOS, SALEN LAS INTEGRACIONES
  filter(USO == 0) %>%
  
  # FILTROS ESCOGIDOS
  filter(ESTACION %in% listaEstacion) %>%
  filter(TSERVICIO %in% listaTServicio) %>%
  filter(TBUS %in% listaTBus) %>%
  filter(SEMANA %in% listaSemana) %>%
  filter(TDIA %in% listaTDia) %>%
  
  # ORGANIZAR INFORMACION
  select(ESTACION,TSERVICIO,TBUS,TDIA,SEMANA,DIA,USOA) %>%
  arrange(ESTACION,TSERVICIO,TBUS,TDIA,SEMANA,DIA) %>%
  
  ## GRUPO PARA ACUMULADO POR DIA
  group_by(ESTACION,TSERVICIO,TBUS,TDIA,SEMANA,DIA) %>%
  summarise(SDia.USOA = sum(USOA)) %>%
  ungroup() %>%
  
  ## GRUPO PARA ACUMULADO POR SEMANA
  group_by(TSERVICIO,TBUS,TDIA,SEMANA) %>%
  summarise(SSemana.USOA = sum(SDia.USOA),
            PSemana.USOA = round(mean(SDia.USOA),0)
            )%>%
  ungroup() 
toc()

# ORGANIZAR NOMBRE DE ESTACION
tic("nombres")
vdata <- udata %>%
#   mutate(ESTACIONN = case_when(
#     ESTACION == "ESTACION 7 AGOSTO" ~ "E.7AGOSTO",
#     ESTACION == "ESTACION ALAMOS" ~ "E.ALAMOS",
#     ESTACION == "ESTACION AMANECER" ~ "E.AMANECER",
#     ESTACION == "ESTACION AMERICAS" ~ "E.AMERICAS",
#     ESTACION == "ESTACION ATANASIO" ~ "E.ATANASIO",
#     ESTACION == "ESTACION BELALCAZAR" ~ "E.BELALCAZAR",
#     ESTACION == "ESTACION BRISAS" ~ "E.BRISAS",
#     ESTACION == "ESTACION BUITRERA" ~ "E.BUITRERA",
#     ESTACION == "ESTACION CABLE CANAVERAL" ~ "E.CCANAVERAL",
#     ESTACION == "ESTACION CALDAS" ~ "E.CALDAS",
#     ESTACION == "ESTACION CALIPSO" ~ "E.CALIPSO",
#     ESTACION == "ESTACION CANAVERALEJO" ~ "E.CANAVERALEJO",
#     ESTACION == "ESTACION CAPRI" ~ "E.CAPRI",
#     ESTACION == "ESTACION CENTRO" ~ "E.CENTRO",
#     ESTACION == "ESTACION CHAPINERO" ~ "E.CHAPINERO",
#     ESTACION == "ESTACION CHIMINANGOS" ~ "E.CHIMINANGOS",
#     ESTACION == "ESTACION CIEN PALOS" ~ "E.CPALOS",
#     ESTACION == "ESTACION CONQUISTADORES" ~ "E.CONQUISTADORES",
#     ESTACION == "ESTACION ERMITA" ~ "E.ERMITA",
#     ESTACION == "ESTACION ESTADIO" ~ "E.ESTADIO",
#     ESTACION == "ESTACION FATIMA" ~ "E.FATIMA",
#     ESTACION == "ESTACION FLORA INDUSTRIAL" ~ "E.FINDUSTRIAL",
#     ESTACION == "ESTACION FLORESTA" ~ "E.FLORESTA",
#     ESTACION == "ESTACION FRAY DAMIAN" ~ "E.FDAMIAN",
#     ESTACION == "ESTACION LIDO" ~ "E.LIDO",
#     ESTACION == "ESTACION LLERAS" ~ "E.LLERAS",
#     ESTACION == "ESTACION MANZANA DEL SABER" ~ "E.MDSABER",
#     ESTACION == "ESTACION MANZANARES" ~ "E.MANZANARES",
#     ESTACION == "ESTACION MELENDEZ" ~ "E.MELENDEZ",
#     ESTACION == "ESTACION NUEVO LATIR" ~ "E.NLATIR",
#     ESTACION == "ESTACION PAMPALINDA" ~ "E.PAMPALINDA",
#     ESTACION == "ESTACION PETECUY" ~ "E.PETECUY",
#     ESTACION == "ESTACION PILOTO" ~ "E.PILOTO",
#     ESTACION == "ESTACION PLAZA CAICEDO" ~ "E.PCAICEDO",
#     ESTACION == "ESTACION PLAZA DE TOROS" ~ "E.PDTOROS",
#     ESTACION == "ESTACION POPULAR" ~ "E.POPULAR",
#     ESTACION == "ESTACION PRADOS DEL NORTE" ~ "E.PDNORTE",
#     ESTACION == "ESTACION PRIMITIVO" ~ "E.PRIMITIVO",
#     ESTACION == "ESTACION REFUGIO" ~ "E.REFUGIO",
#     ESTACION == "ESTACION RIO CALI" ~ "E.RCALI",
#     ESTACION == "ESTACION SALOMIA" ~ "E.SALOMIA",
#     ESTACION == "ESTACION SAN BOSCO" ~ "E.SBOSCO",
#     ESTACION == "ESTACION SAN PASCUAL" ~ "E.SPASCUAL",
#     ESTACION == "ESTACION SAN PEDRO" ~ "E.SPEDRO",
#     ESTACION == "ESTACION SANTA LIBRADA" ~ "E.SLIBRADA",
#     ESTACION == "ESTACION SANTA MONICA" ~ "E.SMONICA",
#     ESTACION == "ESTACION SUCRE" ~ "E.SUCRE",
#     ESTACION == "ESTACION TBLANCA" ~ "E.TBLANCA",
#     ESTACION == "ESTACION TEQUENDAMA" ~ "E.TEQUENDAMA",
#     ESTACION == "ESTACION TORRE DE CALI" ~ "E.TDCALI",
#     ESTACION == "ESTACION TREBOL" ~ "E.TREBOL",
#     ESTACION == "ESTACION TRONCAL UNIDA" ~ "E.TUNIDA",
#     ESTACION == "ESTACION UNIDAD DEPORTIVA" ~ "E.UDEPORTIVA",
#     ESTACION == "ESTACION UNIVERSIDADES" ~ "E.UNIVERSIDADES",
#     ESTACION == "ESTACION VERSALLES" ~ "E.VERSALLES",
#     ESTACION == "ESTACION VILLA NUEVA" ~ "E.VNUEVA",
#     ESTACION == "ESTACION VILLACOLOMBIA" ~ "E.VILLACOLOMBIA",
#     ESTACION == "ESTACION VIPASA" ~ "E.VIPASA",
#     ESTACION == "TERMINAL ANDRES SANIN" ~ "T.ASANIN",
#     ESTACION == "TERMINAL MENGA" ~ "T.MENGA",
#     ESTACION == "TERMINAL PASO DEL COMERCIO" ~ "T.PDCOMERCIO",
#     TRUE  ~ ESTACION
#   )) %>%
#   mutate(ESTACION = ESTACIONN) %>%
#   mutate(ESTACIONN = NULL) %>%
  mutate(TIPO.DIA = TDIA,
         TIPO.SERVICIO = TSERVICIO,
         TIPO.BUS = TBUS)
toc()

#########################################
## GRAFICAS
#########################################

## GRAFICA I
## VARIABLES: x:SEMANA, y:USO ACUMULADO, MES. ANNO, TIPO.DIA 
tic("Grafica I")
ggplot(data = vdata,aes(x = factor(SEMANA),
                        y =  SSemana.USOA,
                        fill = TIPO.DIA
                        )
       ) +
  geom_bar(position = "dodge",
           stat = "identity"
           ) +
  
  ## ETIQUETAS EN LAS BARRAS
  # geom_text(aes(label = comma(SSemana.USOA,digit = 0)),
  #           vjust = -1.25,
  #           size = 3.5,
  #           color = "black"
  # ) +
  geom_text(aes(label = formatC(SSemana.USOA,
                                format = "f",
                                big.mark = ".",
                                digits = 0)),
            position = position_dodge(width = 1.0),
            vjust = 1.25,
            hjust = 0.5,
            size = 2.0
            # angle = 90
            ) +
  
  ## TITULOS EJES
  ggtitle(str_c("TOTAL DE USOS POR SEMANA",
                ""
                # "\nDemanda Promedio Total: ",
                # comma(udata$PUSOATOTAL,digits = 2
                #       )
                )
          ) +
  
  # ORGANIZACION DE EJES
  xlab("SEMANA") +
  ylab("NUMERO DE USOS") +
  theme(
    plot.title = element_text(color="brown4", size=14, face="bold"),
    axis.title.x = element_text(color="brown4", size=14, face="bold"),
    axis.title.y = element_text(color="brown4", size=14, face="bold")
    ) +
  theme(axis.text.x = element_text(#angle = 90,
                                   vjust = 0.5,
                                   size = 6.5
                                   )
        ) +
  
  scale_y_continuous(labels = function(n){
    formatC(n,
            format = "f",
            big.mark = ".",
            digits = 0)
    }) +

  # CUADROS 
  facet_wrap(TIPO.SERVICIO ~ TIPO.BUS,
             scales = "free_y",
             labeller = label_both,
             ncol = 3
             ) 
 
toc()
## FIN GRAFICA I