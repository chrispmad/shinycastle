#' Adds the content of inst/assets/ to shinymanager/
#'
#' @importFrom shiny addResourcePath
#'
#' @noRd
#'
.onLoad <- function(...) {
  shiny::addResourcePath("shinycastle", system.file("assets", package = "shinycastle"))
  shiny::addResourcePath("shinycastle/textures", system.file("assets/textures", package = "shinycastle"))
}

shinymanager_con <- new.env(hash=TRUE)
