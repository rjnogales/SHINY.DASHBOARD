lista_datos     <- c("Usos", "Integraciones")
lista_graficas  <- c("Anno vs Mes", "Mes vs Anno", "Anno")
lista_meses     <- c("Enero","Febrero","Marzo","Abril","Mayo","Junio",
                     "Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre")
lista_tipologia <- c("Sistema", "Estacion", "Padron", "Complementario", "Dual")


ui <- fluidPage(
  
  # Application title
  h1("TABLERO DE INDICADORES. DEMANDA"),
  
  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      ## TIPO DE DATOS: USOS & INTEGRA. 
      # Solo se puede escoger una de las opciones
      prettyRadioButtons(
        inputId = "tipoDatos",
        label = "Escoja Tipo de Datos:",
        choices = lista_datos,
        icon = icon("check"),
        bigger = TRUE,
        status = "info",
        animation = "jelly"
      ),
      
      ## TIPO DE GRAFICA: AÑO . MES : MES . AÑO
      # Solo se puede escoger una de las opciones
      prettyRadioButtons(
        inputId = "tipoGraficas",
        label = "Escoja Tipo de Grafica:",
        choices = lista_graficas,
        icon = icon("check"),
        bigger = TRUE,
        status = "info",
        animation = "jelly"
      ),
      
      ## TIPOLOGIA: SISTEMA, EST, PAD, COM, DUAL
      pickerInput(
        inputId = "Tipologia",
        label = "Seleccione Tipologia:",
        choices = lista_tipologia,
        options = list(
          `actions-box` = TRUE), 
        multiple = TRUE
      ),
      
      ## AÑOS
      pickerInput(
        inputId = "Annos",
        label = "Seleccione Annos:",
        choices = unique(demandao$ANNO) ,
        options = list(
          `actions-box` = TRUE), 
        multiple = TRUE
      ),
      
      ## MESES
      pickerInput(
        inputId = "Meses",
        label = "Seleccione Meses: ",
        choices = lista_meses,
        options = list(
          `actions-box` = TRUE), 
        multiple = TRUE
      ),
      
      downloadButton(outputId = "downData", label = "Descargue Datos"),
      downloadButton(outputId = "downGrafica", label = "Descargue Grafica")
      
      
    ),
    
    # Show Word Cloud
    mainPanel(
      tabsetPanel(
        tabPanel(title = "Grafica",
                 plotOutput("grafica")
        ),
        tabPanel(title = "Datos",
                 DT::dataTableOutput("TipoDatos")
        )
        # tabPanel(title = "Pruebas",
        #          textOutput("pruebas"))
      ) # tabsetpanel
      
    ) # mainpanel
  ) # sidebarlayout
) # ui