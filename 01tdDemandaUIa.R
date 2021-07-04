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

        tabPanel(title = "Datos",
                 DT::dataTableOutput(mesesDatao)
                 ),

        tabPanel(title = "Completo",
                 textOutput(nregistrosBase),
                 textOutput(nregistrosFiltros),
        ),
        
        tabPanel(title = "Tipo de Servicio",
                 textOutput(nregistrosBase),
                 textOutput(nregistrosFiltros),
        ),
        
        tabPanel(title = "Tipo de Bus",
                 textOutput(nregistrosBase),
                 textOutput(nregistrosFiltros),
        )
        
      ) # tabsetpanel
    ) # mainpanel
  ) # sidebarlayout
) # ui
