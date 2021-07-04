
sales <- vroom::vroom("sales_data_sample.csv", col_types = list(), na = "")
sales %>% 
  select(TERRITORY, CUSTOMERNAME, ORDERNUMBER, everything()) %>%
  arrange(ORDERNUMBER)

#> # A tibble: 2,823 x 25
#>    TERRITORY CUSTOMERNAME   ORDERNUMBER QUANTITYORDERED PRICEEACH ORDERLINENUMBER
#>    <chr>     <chr>                <dbl>           <dbl>     <dbl>           <dbl>
#>  1 NA        Online Diecas…       10100              30     100                 3
#>  2 NA        Online Diecas…       10100              50      67.8               2
#>  3 NA        Online Diecas…       10100              22      86.5               4
#>  4 NA        Online Diecas…       10100              49      34.5               1
#>  5 EMEA      Blauer See Au…       10101              25     100                 4
#>  6 EMEA      Blauer See Au…       10101              26     100                 1
#>  7 EMEA      Blauer See Au…       10101              45      31.2               3
#>  8 EMEA      Blauer See Au…       10101              46      53.8               2
#>  9 NA        Vitachrome In…       10102              39     100                 2
#> 10 NA        Vitachrome In…       10102              41      50.1               1
#> # … with 2,813 more rows, and 19 more variables: SALES <dbl>, ORDERDATE <chr>,
#> #   STATUS <chr>, QTR_ID <dbl>, MONTH_ID <dbl>, YEAR_ID <dbl>,
#> #   PRODUCTLINE <chr>, MSRP <dbl>, PRODUCTCODE <chr>, PHONE <chr>,
#> #   ADDRESSLINE1 <chr>, ADDRESSLINE2 <chr>, CITY <chr>, STATE <chr>,
#> #   POSTALCODE <chr>, COUNTRY <chr>, CONTACTLASTNAME <chr>,
#> #   CONTACTFIRSTNAME <chr>, DEALSIZE <chr>

ui <- fluidPage(
  selectInput("territory", "Territory", choices = unique(sales$TERRITORY)),
  selectInput("customername", "Customer", choices = NULL),
  selectInput("ordernumber", "Order number", choices = NULL),
  tableOutput("data")
)

server <- function(input, output, session) {
  territory <- reactive({
    filter(sales, TERRITORY == input$territory)
  })
  observeEvent(territory(), {
    choices <- unique(territory()$CUSTOMERNAME)
    updateSelectInput(inputId = "customername", choices = choices) 
  })
  
  customer <- reactive({
    req(input$customername)
    filter(territory(), CUSTOMERNAME == input$customername)
  })
  observeEvent(customer(), {
    choices <- unique(customer()$ORDERNUMBER)
    updateSelectInput(inputId = "ordernumber", choices = choices)
  })
  
  output$data <- renderTable({
    req(input$ordernumber)
    customer() %>% 
      filter(ORDERNUMBER == input$ordernumber) %>% 
      select(QUANTITYORDERED, PRICEEACH, PRODUCTCODE)
  })
}

 shinyApp(
  ui = ui,
  server = server
)
