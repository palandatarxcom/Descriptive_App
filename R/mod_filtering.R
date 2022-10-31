#' filtering UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_filtering_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny::h2("Data Summary"),
    DT::DTOutput(ns("describe_all")),
  )
}

#' filtering Server Functions
#'
#' @noRd
mod_filtering_server <- function(id, dat){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    output$describe_all <- DT::renderDT({
      DT::datatable(data = dat() %>% explore::describe(out = "text"),
                    rownames = FALSE,
                    selection = 'none',
                    options = list(pageLength = 15))
    }) # render summary
  })
}

## To be copied in the UI
# mod_filtering_ui("filtering_1")

## To be copied in the server
# mod_filtering_server("filtering_1")
