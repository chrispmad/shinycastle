if (interactive()) {

  # define some credentials
  credentials <- data.frame(
    user = c("a", "shinymanager"),
    password = c("b", "12345"),
    stringsAsFactors = FALSE
  )

  library(shiny)
  library(shinycastle)

  ui <- fluidPage(
    tags$h2("My secure application"),
    verbatimTextOutput("auth_output"),
    h5("Critically Sensitive Data"),
    p(id = 'b_number', "Bank number: 394291834932"),
    p(id = 'b_pass', "Bank password: 304291")
  )

  # Wrap your UI with secure_app
  ui <- secure_app_portal(ui, portal_type = 'castle', choose_language = TRUE)

  # change auth ui background ?
  # ui <- secure_app(ui,
  #                  background  = "linear-gradient(rgba(0, 0, 255, 0.5),
  #                  rgba(255, 255, 0, 0.5)),
  #                  url('https://www.r-project.org/logo/Rlogo.png')  no-repeat center fixed;")

  server <- function(input, output, session) {

    # call the server part
    # check_credentials returns a function to authenticate users
    res_auth <- secure_server_portal(
      check_credentials = check_credentials(credentials)
    )

    output$auth_output <- renderPrint({
      reactiveValuesToList(res_auth)
    })

    observe({
      print(input$shinymanager_where)
      print(input$shinymanager_language)
    })

    # your classic server logic

  }

  shinyApp(ui, server)

}
