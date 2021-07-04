#####################################
## 01tdDemandaServer.R
## Función:
## Organiza  la presentación
## shiny de la demanda
## Esto es código Server
#####################################

#####################################
## LIBRERIAS & OTROS
#####################################

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
library(DT)
library(formattable)

server <- function(input, output, session) {
  
  #####################################
  ## FUNCIONES
  #####################################
  
  ## Lee Los Archivos Correspondientes A
  ## Los Meses Seleccionados
  leeDatos <- function(meses){
    # showModal(modalDialog("Leyendo Informacion ...", footer = NULL))
    mesesf <- str_c(carpetaData,"/",prefijoData,meses,".Rds")
    fdata <- mesesf %>%
      map_dfr(readRDS)
    # removeModal()
    return (fdata)
  } 
  
  #####################################
  ## VARIABLES
  #####################################
  
  #####################################
  ## PROCESA LOS DATOS
  #####################################
  
  ## Lee Los Meses Escogidos & Retorna
  ## Una Tabla Con Todos Esos Meses
  
  dataBasef <- reactive({
    # Si se ha seleccionado información
    if(!is.null(input$Mesesi)){
      # fdata <- leeDatos(input$Mesesi)
      mesesf <- str_c(carpetaData,"/",prefijoData,meses,".Rds")
      fdata <- mesesf %>%
        map_dfr(readRDS)
    }
    else {
      fdata <- NULL
    }
    fdata
  })
  
  dataFiltrosf <- reactive({
    # Si NO se ha seleccionado información
    if(!is.null(input$Semanai) &
       !is.null(input$DSemanai) &
       !is.null(input$Diai) &
       !is.null(input$TDiai) &
       !is.null(input$Horai) &
       !is.null(input$CHorai)
    ){
      data <- dataBasef() %>%
        filter(SEMANA %in% input$Semanai) %>%
        filter(SEMANA %in% input$DSemanai) %>%
        filter(SEMANA %in% input$Diai) %>%
        filter(SEMANA %in% input$TDiai) %>%
        filter(SEMANA %in% input$Horai) %>%
        filter(SEMANA %in% input$CHorai)
    }
    else {
      data <- NULL
    }
    data
  })
  
  observe({
    if(!is.null(input$Mesesi)){
      # INFRAESTRUCTURA
      listaEstacion  <- as.character(unique(dataBasef()$ESTACION))
      listaTServicio <- as.character(unique(dataBasef()$TSERVICIO))
      listaTBus      <- as.character(unique(dataBasef()$TBUS))
      # CALENDARIO
      listaSemana    <- unique(dataBasef()$SEMANA)
      listaTDia      <- as.character(unique(dataBasef()$TDIA))
      
      # INFRAESTRUCTURA
      updatePickerInput(session, 
                        inputId = "Estacioni",
                        choices = str_sort(listaEstacion))
      updatePickerInput(session, 
                        inputId = "TServicioi",
                        choices = str_sort(listaTServicio))
      updatePickerInput(session, 
                        inputId = "TBusi",
                        choices = str_sort(listaTBus))
      # CALENDARIO
      updatePickerInput(session,
                        inputId = "Semanai",
                        choices = sort(listaSemana))
      updatePickerInput(session,
                        inputId = "TDiai",
                        choices = str_sort(listaTDia))
    }
  }) 
  
  # DATOS BASE
  output$nregistrosBase <- renderText({
    nregistrosBase <- str_c("Numero De Registros Base: ",
                            comma(nrow(dataBasef()),digits = 0))
  })
  
  # DATOS FILTROS
  output$nregistrosFiltros <- renderText({
    nregistrosFiltros <- str_c("Numero De Registros Filtros: ",
                               comma(nrow(dataFiltrosf()),digits = 0))
  })
  
  
  # TABLA DE DATOS
  output$mesesDatao <- DT::renderDataTable({
    mesesDatat <- dataBasef()
 
  })
  
  ## GRAFICAS
  
  
  #####################################
  ## PRUEBAS
  #####################################
  
  # Muestra los datos
  # output$Meseso <- renderText({
  #   input$Mesesi
  # })
  
}

################################################### FIN SERVER #########################################

#####################################
## Versión 01
## 01tdDemandaUI.R
## Función:
## Organiza  la presentación
## shiny de la demanda
## Esto es código UI
#####################################

#####################################
## VARIABLES
#####################################

## INFORMACION LECTURA DE DATOS

## carpeta del directorio donde se encuentran los datos & proyecto
## LINUX
carpetaData <- "/home/rjnogales/Dropbox/10.DRIVE/R.SHINY/data/"

# prefijo del nombre del archivo correspondiente
# al mes: dmes+año+mes
prefijoData <- "dmes"

## LISTA DE ARCHIVOS
pathData       <- carpetaData
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
## CODIGO
#####################################

ui <- fluidPage(
  
  ## TITULO DE LA APLICACION
  h1("TABLERO DE INDICADORES. DEMANDA BASICA"),
  
  ## PANEL
  sidebarLayout(
    # Barra Donde Se Escogen Datos & Se Filtran 
    sidebarPanel(
      
      ## FUENTE DE DATOS
      helpText("FILTROS.FECHA.MES"),
      ## AÑO.MESES
      pickerInput(
        inputId = "Mesesi",
        label = "Seleccione Meses (Maximo Tres): ",
        multiple = TRUE,
        choices = listaMeses,
        options = pickerOptions(
          maxOptions = 3)
      ),
      
      # ## FILTROS.INFRAESTRUCTURA
      helpText("FILTROS.INFRAESTRUCTURA"),
      ## 1.ESTACION
      pickerInput(
        inputId = "Estacioni",
        label = "Seleccione Infraestructura: ",
        multiple = TRUE,
        choices = NULL,
        options = pickerOptions(
          `actions-box` = TRUE)
      ),
      
      # ## FILTROS.CALENDARIO
      helpText("FILTROS.CALENDARIO.SEMANA"),
      ## 2.SEMANA
      pickerInput(
        inputId = "Semanai",
        label = "Seleccione Semana: ",
        multiple = TRUE,
        choices = NULL,
        options = pickerOptions(
          `actions-box` = TRUE)
      ),
      
      ## 3.TIPO DE SERVICIO
      pickerInput(
        inputId = "TServicioi",
        label = "Seleccione Tipo de Servicio: ",
        multiple = TRUE,
        choices = NULL,
        options = pickerOptions(
          `actions-box` = TRUE)
      ),
      ## 4.TIPO DE BUS
      pickerInput(
        inputId = "TBusi",
        label = "Seleccione Tipo de Bus: ",
        multiple = TRUE,
        choices = NULL,
        options = pickerOptions(
          `actions-box` = TRUE)
      ),
      
      ## 5.TIPO DE DIA
      pickerInput(
        inputId = "TDiai",
        label = "Seleccione Tipo de Dia: ",
        multiple = TRUE,
        choices = NULL,
        options = pickerOptions(
          `actions-box` = TRUE)
      )
      
    ),
    
    ## PANEL PRINCIPAL CON PESTAÑAS: Gráficas & Datos
    mainPanel( 
      tabsetPanel(
        
        tabPanel(title = "Pruebas",
                 textOutput("Meseso"),
                 helpText("Display 5 records by default.")
        ),
        
        id = 'dataset',
        tabPanel(title = "Datos",
                 DT::dataTableOutput("mesesDatao")
                 ),

        tabPanel(title = "Completo",
                 textOutput("nregistrosBase"),
                 textOutput("nregistrosFiltros"),
        ),

        tabPanel(title = "Tipo de Servicio",
                 textOutput("nregistrosBase"),
                 textOutput("nregistrosFiltros"),
        ),

        tabPanel(title = "Tipo de Bus",
                 textOutput("nregistrosBase"),
                 textOutput("nregistrosFiltros"),
        )
        
      ) # tabsetpanel
    ) # mainpanel
  ) # sidebarlayout
) # ui

################################################### FIN UNIT INTERFACE ###################################

#####################################
# EXECUTE
#####################################

shinyApp(
  ui = ui,
  server = server
)