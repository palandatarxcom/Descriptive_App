## ---------------------------
##
## Script name: page_dataview.R
##
## Purpose of script: view the data and simple summary
##
## Author: Lin Yong
##
## Date Created: 2022-11-10
##
## Copyright (c) DataRx, 2022
## Email: yong.lin@datarx.cn
##
## ---------------------------
##
## Notes:
##
##
## ---------------------------


box::use(
  shiny = shiny[...],
  DT = DT[...],
  base64url = base64url[base64_urldecode, ...],
  vroom = vroom[vroom, ...],
  dplyr = dplyr[select, ...],
  explore = explore[describe, ...]
)


box::use(
  app/logic/table_utils[show_DT_table, preprocess_df, ...]
)


#' @export
dataview_ui <- function(id) {
  ns <- NS(id)
  tagList(
    titlePanel("浏览数据集"),

    sidebarLayout(
      sidebarPanel(
        varSelectInput(ns("variables"), "Variable:", NULL, multiple = TRUE)
      ),
      mainPanel(
        h2("数据集"),
        DT$DTOutput(ns("view")),
        h2("简单统计"),
        DT$DTOutput(ns("describe_all")),
      )
    )
  )
}


#' @export
dataview_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    dataset <- reactiveValues()

    observe({
      query <- parseQueryString(session$clientData$url_search)
      if (!is.null(query[["access"]])) {
        # use vroom to read a data file from a specified URL
        dataset$path <- base64url$base64_urldecode(query[["access"]])
        dataset$data <- preprocess_df(
                          vroom$vroom(base64url$base64_urldecode(query[["access"]]),
                                  show_col_types = FALSE)
                      )
      }
    })

    observeEvent(dataset$data, {
      updateVarSelectInput(
        session,
        "variables",
        data = dataset$data)
    })

    output$describe_all <- DT$renderDT({
      if (!is.null(dataset$data))
        show_DT_table(dataset$data |> explore$describe(out = "text"))
    }) # render summary

    output$view <- DT$renderDT({
      if (length(input$variables) == 0)
        dataset$selected <- dataset$data
      else
        dataset$selected <- dataset$data %>% dplyr$select(!!!input$variables)

      if (!is.null(dataset$selected))
        show_DT_table(dataset$selected)
    }) # render data table

    return(reactive(dataset$selected))
  })
}
