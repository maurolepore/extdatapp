source("packages.R")
source("functions.R")

paths <- installed_files(regexp = supported_extensions())

ui <- fluidPage(
  selectInput("dataset", label = format_label("Dataset"), choices = files(paths)),
  verbatimTextOutput("table")
)

server <- function(input, output, session) {
  dataset <- reactive({
    find_dataset(input$dataset, paths)
  })

  output$table <- renderPrint({
    dataset()
  })
}

shiny::shinyApp(ui, server)

