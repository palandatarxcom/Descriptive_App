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
        # dataset$path <- base64_urldecode(query[['access']])
        # L1VzZXJzL2xpbnlvbmcvRG93bmxvYWRzL2xpbmVsaXN0X2NsZWFuZWQucmRz
        # decode -> /var/data/...../.csv
        dataset$data <- readRDS(base64_urldecode(query[['access']]))
        # read a data.frame from disk
        # dataset$data <- read.cvs / vroom::read() / arrow::feather()
      }
    })


    output$describe_all <- DT::renderDT({
      DT::datatable(data = dataset$data %>% explore::describe(out = "text"),
                    rownames = FALSE,
                    selection = 'none',
                    options = list(pageLength = 15))
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
