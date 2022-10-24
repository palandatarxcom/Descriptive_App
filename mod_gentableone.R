#' gentableone UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_gentableone_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' gentableone Server Functions
#'
#' @noRd 
mod_gentableone_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_gentableone_ui("gentableone_1")
    
## To be copied in the server
# mod_gentableone_server("gentableone_1")
