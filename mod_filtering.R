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
 
  )
}
    
#' filtering Server Functions
#'
#' @noRd 
mod_filtering_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_filtering_ui("filtering_1")
    
## To be copied in the server
# mod_filtering_server("filtering_1")
