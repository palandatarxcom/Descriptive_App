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

    sidebarLayout(
      sidebarPanel(
        varSelectInput(ns("variables"), "Variable:", NULL, multiple = TRUE)
      ),
      mainPanel(
        shiny::h2("数据集"),
        DT::DTOutput(ns("view")),
        shiny::h2("简单统计"),
        DT::DTOutput(ns("describe_all")),
      )
    )
  )
}

show_DT_table <- function(dat) {
  DT::datatable(data = dat,
                rownames = FALSE,
                selection = 'none',
                options = list(pageLength = 15, scrollX = TRUE))
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

    observeEvent(dataset$data, {
      updateVarSelectInput(
        session,
        "variables",
        data = dataset$data)
    })

    output$describe_all <- DT::renderDT({
      if(!is.null(dataset$data))
        show_DT_table(dataset$data %>% explore::describe(out = "text"))
    }) # render summary

    output$view <- DT::renderDT({
      if (length(input$variables) == 0)
        # return(show_DT_table(dataset$data))
        dataset$selected <- dataset$data
      else
        dataset$selected <- dataset$data %>% dplyr::select(!!!input$variables)

      return(show_DT_table(dataset$selected))
    }) # render data table

    return(reactive(dataset$selected))
  })
}
