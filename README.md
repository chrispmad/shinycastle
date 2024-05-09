# shinycastle

> A medieval skin for the fantastic {shinymanager} package.

To learn how to use the {shinymanager} package, please turn to these demos:

* On Shiny-server: http://shinyapps.dreamrs.fr/shinymanager-demo/
* On shinyapps.io : https://dreamrs.shinyapps.io/shinymanager-demo/


Online documentation : https://datastorm-open.github.io/shinymanager/

### Example

````
library(shiny)
devtools::load_all(".")

credentials <- data.frame(
  user = c("a","victor"),
  password = c("b","c")
)

# app
ui <- fluidPage(

  shinyjs::useShinyjs(),

  # authentication module
  auth_ui_custom(
    id = "auth"
  ),

  # result of authentication
  verbatimTextOutput(outputId = "res_auth"),

  # classic app
  headerPanel('Iris k-means clustering'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', names(iris)),
    selectInput('ycol', 'Y Variable', names(iris),
                selected=names(iris)[[2]]),
    numericInput('clusters', 'Cluster count', 3,
                 min = 1, max = 9)
  ),
  mainPanel(
    plotOutput('plot1')
  )
)

server <- function(input, output, session) {

  # authentication module
  auth <- callModule(
    module = auth_server_custom,
    id = "auth",
    check_credentials = check_credentials(credentials)
  )

  output$res_auth <- renderPrint({
    reactiveValuesToList(auth)
  })

  # classic app
  selectedData <- reactive({

    req(auth$result)  # <---- dependency on authentication result

    iris[, c(input$xcol, input$ycol)]
  })

  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })

  output$plot1 <- renderPlot({
    palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
              "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
}

shinyApp(ui, server)

````
