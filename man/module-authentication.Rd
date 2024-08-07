% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/module-auth-castle.R, R/module-auth.R
\name{module-authentication}
\alias{module-authentication}
\alias{auth_ui_portal}
\alias{auth_server_portal}
\alias{auth_server}
\title{Authentication module}
\usage{
auth_ui_portal(
  id,
  status = "primary",
  tags_top = NULL,
  tags_bottom = NULL,
  background = NULL,
  choose_language = NULL,
  lan = NULL,
  ...
)

auth_server_portal(
  input,
  output,
  session,
  check_credentials,
  use_token = FALSE,
  lan = NULL,
  portal_type = NULL
)

auth_server(
  input,
  output,
  session,
  check_credentials,
  use_token = FALSE,
  lan = NULL
)
}
\arguments{
\item{id}{Module's id.}

\item{status}{Bootstrap status to use for the panel and the button.
Valid status are: \code{"default"}, \code{"primary"}, \code{"success"},
\code{"warning"}, \code{"danger"}.}

\item{tags_top}{A \code{tags (div, img, ...)} to be displayed on top of the authentication module.}

\item{tags_bottom}{A \code{tags (div, img, ...)} to be displayed on bottom of the authentication module.}

\item{background}{A optional \code{css} for authentication background. See example.}

\item{choose_language}{\code{logical/character}. Add language selection on top ? TRUE for all supported languages
or a vector of possibilities like \code{c("en", "fr", "pt-BR", "es", "de", "pl", "ja", "el", "id", "zh-CN")}. If enabled, \code{input$shinymanager_language} is created}

\item{lan}{A language object. See  \code{\link{use_language}}}

\item{...}{: Used for old version compatibility.}

\item{input, output, session}{Standard Shiny server arguments.}

\item{check_credentials}{Function with two arguments (\code{user},
the username provided by the user and \code{password}, his/her password).
Must return a \code{list} with at least 2 (or 4 in case of sqlite) slots :
\itemize{
 \item \strong{result} : logical, result of authentication.
 \item \strong{user_info} : \code{list}. What you want about user ! (sqlite : the line in \code{db} corresponding to the user).
 \item \strong{expired} : logical, is user has expired ? Always \code{FALSE} if \code{db} doesn't have a \code{expire} column. Optional.
 \item \strong{authorized} : logical, is user can access to his app ? Always \code{TRUE} if \code{db} doesn't have a \code{applications} column. Optional.
}}

\item{use_token}{Add a token in the URL to check authentication. Should not be used directly.}
}
\value{
A \code{reactiveValues} with 3 slots :
 \itemize{
  \item \strong{result} : logical, result of authentication.
  \item \strong{user} : character, name of connected user.
  \item \strong{user_info} : information about the user.
 }

A \code{reactiveValues} with 3 slots :
 \itemize{
  \item \strong{result} : logical, result of authentication.
  \item \strong{user} : character, name of connected user.
  \item \strong{user_info} : information about the user.
 }
}
\description{
Authentication module
}
\examples{
if (interactive()) {
  
  library(shiny)
  library(shinymanager)
  
  # data.frame with credentials info
  # credentials <- data.frame(
  #   user = c("fanny", "victor"),
  #   password = c("azerty", "12345"),
  #   comment = c("alsace", "auvergne"),
  #   stringsAsFactors = FALSE
  # )
  
  # you can hash the password using scrypt
  # and adding a column is_hashed_password
  # data.frame with credentials info
  credentials <- data.frame(
    user = c("fanny", "victor"),
    password = c(scrypt::hashPassword("azerty"), scrypt::hashPassword("12345")),
    is_hashed_password = TRUE,
    comment = c("alsace", "auvergne"),
    stringsAsFactors = FALSE
  )
  
  # app
  ui <- fluidPage(
    
    # authentication module
    auth_ui(
      id = "auth",
      # add image on top ?
      tags_top = 
        tags$div(
          tags$h4("Demo", style = "align:center"),
          tags$img(
            src = "https://www.r-project.org/logo/Rlogo.png", width = 100
        )
      ),
      # add information on bottom ?
      tags_bottom = tags$div(
        tags$p(
          "For any question, please  contact ",
          tags$a(
            href = "mailto:someone@example.com?Subject=Shiny\%20aManager",
            target="_top", "administrator"
          )
        )
      ),
      # change auth ui background ?
      # https://developer.mozilla.org/fr/docs/Web/CSS/background
      background  = "linear-gradient(rgba(0, 0, 255, 0.5),
                       rgba(255, 255, 0, 0.5)),
                       url('https://www.r-project.org/logo/Rlogo.png');", 
      # set language ?
      lan = use_language("fr")
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
      module = auth_server,
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
  
}
}
