#' varselection UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_varselection_ui <- function(id){
  ns <- NS(id)
  tagList(
    titlePanel("选择变量"),
    tableOutput(ns("table")),
  )
}

#' varselection Server Functions
#'
#' @noRd
mod_varselection_server <- function(id, dat) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    output$table <- renderTable({
      head(dat())
    })

    return(reactive(dat()))
  })
}
