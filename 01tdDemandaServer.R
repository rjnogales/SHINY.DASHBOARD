#####################################
## 01tdDemandaServer.R
## Función:
## Organiza  la presentación
## shiny de la demanda
## Esto es código Server
#####################################

#####################################
## FUNCIONES
#####################################

## Lee Los Archivos Correspondientes A
## Los Meses Seleccionados
leeDatos <- function(meses){
  # showModal(modalDialog("Leyendo Informacion ...", footer = NULL))
  mesesf <- str_c(carpetaProyecto,carpetaData,"/",prefijoData,meses,".Rds")
  fdata <- mesesf %>%
    map_dfr(readRDS)
  # removeModal()
  return (fdata)
} 

server <- function(input, output, session) {
  
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
      fdata <- leeDatos(input$Mesesi)
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
    mesesDatat
  })
  
  ## GRAFICAS
  

  #####################################
  ## PRUEBAS
  #####################################
  
  ## Muestra los datos
  # output$Meseso <- renderText({
  #   input$Mesesi
  #   
  # })
  
}