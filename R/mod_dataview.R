#' dataview UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_dataview_ui <- function(id){
  ns <- NS(id)
  tagList(
    titlePanel("浏览数据集"),
    shiny::br(),
    DT::DTOutput(ns("view")),
    shiny::h2("Data Summary"),
    DT::DTOutput(ns("describe_all")),
  )
}

#' dataview Server Functions
#'
#' @noRd
mod_dataview_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    dataset <- reactiveValues()

    observe({
      query <- parseQueryString(session$clientData$url_search)
      if (!is.null(query[['access']])) {
        # use vroom to read a data file from a specified URL
        dataset$path <- base64url::base64_urldecode(query[['access']])
        dataset$data <- vroom::vroom(base64url::base64_urldecode(query[['access']]), show_col_types = FALSE)
      }
    })


    output$describe_all <- DT::renderDT({
      if(!is.null(dataset$data)) {
      DT::datatable(data = dataset$data %>% explore::describe(out = "text"),
                    rownames = FALSE,
                    selection = 'none',
                    options = list(pageLength = 15))
      }
    }) # render summary

    output$view <- DT::renderDT({
      DT::datatable(data = dataset$data,
                    rownames = FALSE,
                    selection = 'none',
                    options = list(pageLength = 15, scrollX = TRUE))
    }) # render data table

    return(reactive(dataset$data))
  })
}
