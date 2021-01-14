library(shiny)

datasets <- function() {
  list.files(
    system.file("extdata", package = "testdataprep.private")
  )
}

ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:r2dii.data")),
  tableOutput("table")
)

server <- function(input, output, session) {
  dataset <- reactive({
    get(input$dataset, "package:r2dii.data")
  })
  
  output$table <- renderTable({
    dataset() 
  })
}

shiny::shinyApp(ui, server)

