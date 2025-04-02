library(shiny)
library(shinycastle)
library(ggplot2)

credentials <- data.frame(
  user = c("user"),
  password = c("pass")
)

ui <- fluidPage(
  h2("Welcome to the app!"),
  plotOutput('my_ggplot')
)

ui = shinycastle::secure_app(ui)

server <- function(input, output, session) {
  shinycastle::secure_server(
    check_credentials = check_credentials(credentials)
  )

  output$my_ggplot = renderPlot({
    ggplot(iris) +
      geom_histogram(aes(Petal.Length,fill=Species))
  })
}



shinyApp(ui, server)
