library(shiny)
library(dplyr, warn.conflicts = FALSE)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput('dataset', 'Escoja Datos', c('mtcars', 'iris')),
      selectInput('columns', 'Columnas', "")
    ),
    mainPanel(
      
    )
  )
)

server <- function(input, output, session){
    outVar = reactive({
      mydata = get(input$dataset)
      names(mydata)
    })
    
    observe({
      updateSelectInput(session, "columns",
                        choices = outVar())
    })
}

shinyApp(
  ui = ui,
  server = server
)