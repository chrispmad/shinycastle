library(shiny)
library(bslib)

test = FALSE

if(test){
  date_select = shiny::dateInput('date_input','Date',min = '1900-01-01',max = '2080-01-01')

  dropdown_select = shiny::selectizeInput('dropdown_input',"Letter",choices = c(LETTERS))

  radio_select = shiny::radioButtons('radio_input',"Mode",choices = c("Standard","Turbo"))

  the_sidebar = sidebar(
    open = 'always',
    title = "Hi",
    date_select,
    dropdown_select,
    radio_select
  )


  page_fallout = function(..., title = NULL, theme = bs_theme(), lang = NULL,
                          major_buttons = NULL){
    # shiny::tagList(
    # shiny::div(class = "tv-case",
    # shiny::div(class = "tv-monitor",
    bslib::page_fixed(..., shiny::div(major_buttons, class = "major-buttons"), title = NULL, theme = theme, lang = NULL)
    # )
    # ),
    # )
  }

  tabsetPanel_fallout = function (..., id = NULL, selected = NULL, type = c("falloutbuttons"), header = NULL, footer = NULL)
  {
    if (!is.null(id))
      selected <- shiny::restoreInput(id = id, default = selected)
    type <- match.arg(type)
    tabset <- bslib:::buildTabset(..., ulClass = paste0("nav nav-",
                                                        type), id = id, selected = selected)
    tags$div(class = "tabbable", !!!bslib:::dropNulls(list(tabset$navList,
                                                           header, tabset$content, footer)))
  }


  navset_falloutbuttons = function (..., id = NULL, selected = NULL, header = NULL, footer = NULL)
  {
    falloutbuttons <- tabsetPanel_fallout(..., type = "falloutbuttons", id = id, selected = selected,
                                          header = header, footer = footer)
    bslib:::as_fragment(falloutbuttons)
  }

  fallout_theme = bslib::bs_theme(
    base_font = "Arial",     # Optional: specify a base font
    bg = "darkgreen",          # Optional: set background color
    fg = "lightgreen"
  )

  fallout_theme = bs_add_rules(fallout_theme,
                               "
                             .nav-falloutbuttons {
                                position: absolute;
                                margin-left: 30%; margin-right: 30%;
                                margin-top: 50rem; margin-bottom: 5rem;
                             }
                             .tv-case {
                                position: absolute;
                                width: 60rem; height: 50rem;
                                left: 30rem; top: 5rem;
                                border-radius: 8%;
                                background: darkgrey;
                             }
                             .tv-monitor {
                                position: relative;
                                width: 90%; height: 90%;
                                left: 5%; top: 5%;
                                border-radius: 8%;
                                background: green;
                             }
                             ")

  items_nav_panel = layout_sidebar(
    fillable = T,
    sidebar = the_sidebar,
    card(
      bslib::navset_bar(
        bslib::nav_panel(
          title = "Weapons"
        ),
        bslib::nav_panel(
          title = "Apparel"
        ),
        bslib::nav_panel(
          title = "Aid"
        ),
        bslib::nav_panel(
          title = "Misc"
        ),
        bslib::nav_panel(
          title = "Ammo"
        )
      ),
      height = 500)
  )

  ui <- page_fallout(
    theme = fallout_theme,
    major_buttons = navset_falloutbuttons(
      nav_panel(
        title = "STATS",
      ),
      nav_panel(
        title = "ITEMS",
        items_nav_panel
      ),
      nav_panel(
        title = "DATA"
      )
    )
  )

  htmltools::html_print(ui)

  server <- function(input, output, session) {

  }

  shinyApp(ui, server)
}
