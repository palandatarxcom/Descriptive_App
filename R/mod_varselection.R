global_data <- reactiveVal(NULL)

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
    sidebarLayout(
      sidebarPanel(
        # actionButton(ns("go"), "Get variables"),
        varSelectInput(ns("variables"), "Variable:", NULL, multiple = TRUE)
      ),

      mainPanel(
        tableOutput(ns("data"))
      )
    )
  )
}

#' varselection Server Functions
#'
#' @noRd
mod_varselection_server <- function(id, dat) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    dataset <- reactiveValues()

    # observeEvent(input$go, {
    #   message("go")
    #   updateVarSelectInput(
    #     session,
    #     "variables",
    #     data = dat())
    # })

    observeEvent(dat(), {
        updateVarSelectInput(
          session,
          "variables",
          data = dat())
    })

    output$data <- renderTable({
      if (length(input$variables) == 0) return(head(dat()))
      dataset$data <- dat() %>% dplyr::select(!!!input$variables)
      return(head(dataset$data))
    }, rownames = TRUE, striped = TRUE)

    return(reactive(dataset$data))
  })
}
