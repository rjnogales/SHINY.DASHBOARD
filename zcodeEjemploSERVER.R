# Aplica Filtros & Selecciones a Demanda
fdata <- reactive({
  
  demanda <- demandao
  
  ## PARA CUANDO NO SE HA
  ## SELECCIONADO NADA
  
  if(!is.null(input$Annos)){
    fannos <- input$Annos
  } else {
    fannos <- unique(demanda$ANNO)  
  }
  
  if(!is.null(input$Meses)){
    fmeses <- input$Meses
  } else {
    fmeses <- lista_meses
  }
  
  if(!is.null(input$Tipologia)){
    ftipologia <- input$Tipologia
  } else {
    ftipologia <- lista_tipologia[1]
  }
  
  ## ORGANIZACION DE LA INFORMACION
  data <-demanda %>%
    ## Filtro por Años & Meses
    filter(ANNO %in% as.integer(fannos)) %>%
    filter(NAMEM %in% substr(fmeses,1,3)) %>%
    filter(substr(TIPOLOGIA,3,5) %in% substr(toupper(ftipologia),1,3)) %>%
    mutate(TIPOLOGIA.NOMBRE = case_when(
      substr(TIPOLOGIA,3,5) == "SIS" ~ "Sistema",
      substr(TIPOLOGIA,3,5) == "EST" ~ "Estacion",
      substr(TIPOLOGIA,3,5) == "PAD" ~ "Padron",
      substr(TIPOLOGIA,3,5) == "COM" ~ "Complementario",
      substr(TIPOLOGIA,3,5) == "DUA" ~ "Dual",
      TRUE ~ "XXXX"
    )) %>%
    select(1:7,TIPOLOGIA.NOMBRE,8:18)
  
  data
})

## Muestra los datos
output$TipoDatos <- DT::renderDataTable({
  data <- fdata()
  data
})

titulo <- reactive ({
  data <- fdata()
  texto <- unique(data$TIPOLOGIA.NOMBRE)
  texto
})


#####################################
## PROCESA LAS GRAFICAS
#####################################

## Define la gráfica
plotDemanda <- reactive({
  
  ## Anno vs Mes
  if(input$tipoGraficas == "Anno vs Mes"){
    
    p <- ggplot(fdata(),aes(x = reorder(factor(NAMEM),MES),
                            y = VALOR,
                            # fill = TIPOLOGIA.NOMBRE,
                            # label = ms(VALOR))) +
                            fill = TIPOLOGIA.NOMBRE)) +
      # barras
      geom_bar(position = "dodge",
               stat = "identity") +
      
      # titulo
      ggtitle(str_c("Grafica: ",input$tipoGraficas," Validacion: ",
                    input$tipoDatos," Tipologia: ",
                    paste(titulo(),collapse = " "))
      )+
      theme(plot.title = element_text(size = 18)) +
      
      # Valores en la barra
      # geom_text(size = 3,
      #           position = position_dodge(width=0.8),
      #           vjust=0.5,
      #           angle = 90) +
      
      # Formato de Datos en el Eje Y
      scale_y_continuous(labels = label_comma()) +
      
      # Titulos Ejes
      labs(y = paste("Cantidad de ",input$tipoDatos," Totales",
                     "\n por Tipologia: ",paste(titulo(),collapse = " ")),
           x = "Meses") +
      
      # Varias Cuadros
      facet_wrap(~factor(ANNO),
                 nrow=1) +
      
      # Ajuste Etiquetas Eje X
      theme(axis.text.x = element_text(angle = 90,
                                       size = rel(0.9),
                                       vjust = -0.05 )) +
      # Leyenda en la Base
      theme(legend.position = "bottom")
  }
  
  ## Mes vs Anno
  if(input$tipoGraficas == "Mes vs Anno"){
    
    p <- ggplot(fdata(),aes(x = factor(ANNO),
                            y = VALOR,
                            # fill = factor(MES),
                            # label = ms(VALOR))) +
                            fill = TIPOLOGIA.NOMBRE)) +
      # barrass
      geom_bar(position = "dodge",
               stat = "identity") +
      
      # titulo
      ggtitle(str_c("Grafica: ",input$tipoGraficas," Validacion: ",
                    input$tipoDatos," Tipologia: ",
                    paste(titulo(),collapse = " "))
      )+
      theme(plot.title = element_text(size = 18)) +
      
      # Valores de la barra
      # geom_text(size = 3,
      #           position = position_dodge(width=0.8),
      #           vjust=0.5,
      #           angle = 90) +
      
      # Varios cuadros
      facet_wrap(~reorder(factor(NAMEM),MES),
                 nrow=1) +
      
      # Formato Eje Y
      scale_y_continuous(labels = label_comma()) +
      
      # Etiquetes Eje Y & Eje X
      labs(y = str_c("Cantidad de ",input$tipoDatos," Totales",
                     "\n por Tipologia: ",paste(titulo(),collapse = " ")),
           x = "Annos") +
      
      # Ajuste etiquetas Eje X
      theme(axis.text.x = element_text(angle = 90,
                                       size = rel(0.9),
                                       vjust = -0.05 )) +
      
      # Leyenda en la Base
      theme(legend.position = "bottom")
  }
  
  ## AÑO
  if(input$tipoGraficas == "Anno"){
    
    p <- ggplot(fdata(),aes(x = factor(ANNO),
                            y = VALOR,
                            # fill = factor(ANNO),
                            # label = ms(VALOR))) +
                            fill = TIPOLOGIA.NOMBRE)) +
      
      # barras
      geom_bar(position = "dodge",
               stat = "identity") +
      
      # titulo
      ggtitle(str_c("Grafica: ",input$tipoGraficas," Validacion: ",
                    input$tipoDatos," Tipologia: ",
                    paste(titulo(),collapse = " "))
      )+
      theme(plot.title = element_text(size = 18)) +
      
      # VAlores en la barra
      # geom_text(size = 3,
      #           position = position_dodge(width=0.5),
      #           vjust=0.5,
      #           angle = 0) +
      
      # VArios cuadros
      # facet_wrap(~reorder(factor(NAMEM),MES),
      #            nrow=1) +
      
    # Formato Eje Y
    scale_y_continuous(labels = label_comma()) +
      
      # Etiquetas Eje X & Eje Y
      labs(y = str_c("Cantidad de ",input$tipoDatos," Totales",
                     "\n por Tipologia: ",paste(titulo(),collapse = " ")),
           x = "Annos") +
      
      # Ajuste etiquetas Eje X
      theme(axis.text.x = element_text(angle = 90,
                                       size = rel(0.9),
                                       vjust = -0.05 )) +
      
      # Leyenda en la Base
      theme(legend.position = "bottom")
    
  }
  p
  
})

output$grafica <- renderPlot({
  p <- plotDemanda()
  p
})

#####################################
## PROCESA BOTONES DE DESCARGA
#####################################

output$downData <- downloadHandler(
  
  # Guarda el data del momento
  filename = paste("Demanda_",input$tipoDatos,".csv",sep=""),
  content = function(file) {
    write.csv(fdata(),file,row.names = FALSE)
  }
)

output$downGrafica <- downloadHandler(
  
  # Guarda la grafica del momento
  filename = function() { paste("Demanda_",input$tipoDatos,"_",
                                input$tipoGraficas,".png",sep="")},
  content = function(file) {
    ggsave(file,plotDemanda())
  }
)

#####################################
## PRUEBAS
#####################################

# output$pruebas <- renderText({
#   paste(titulo(),collapse = " ")
# })

}