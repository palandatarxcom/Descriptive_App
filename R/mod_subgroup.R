#' subgroup UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_subgroup_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' subgroup Server Functions
#'
#' @noRd 
mod_subgroup_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_subgroup_ui("subgroup_1")
    
## To be copied in the server
# mod_subgroup_server("subgroup_1")
