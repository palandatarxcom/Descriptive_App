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
  explore = explore[describe, ...],
  datamods = datamods[...]
)


box::use(
  app/logic/table_utils[show_DT_table, preprocess_df, ...]
)


#' @export
dataview_ui <- function(id){
  ns <- NS(id)
  tagList(
    titlePanel("浏览数据集"),
    p("blah, blah, blah"),
    # sidebarLayout(
    #   sidebarPanel(
    #     # varSelectInput(ns("variables"), "Variable:", NULL, multiple = TRUE)
    #   ),
    #   mainPanel(
        h3("数据集描述"),
        div(id = "dv_statistic",
            wellPanel(
              DT$DTOutput(ns("describe_all"))
            )
        ),
        h3("数据集更新"),
        div(id = "dv_update_variable",
            wellPanel(
              datamods$update_variables_ui(id = ns("update"), title = NULL)
            )
        ),
        h3("数据预览"),
        div(id = "dv_preview",
            wellPanel(
              DT$DTOutput(ns("view"))
            )
        ),
      # )
    # )
  )

}


#' @export
dataview_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    dataset <- reactiveValues(data = NULL)

    observe({
      query <- parseQueryString(session$clientData$url_search)
      if (!is.null(query[["access"]])) {
        # use vroom to read a data file from a specified URL
        dataset$path <- base64url$base64_urldecode(query[["access"]])
        dataset$data <- preprocess_df(
                          vroom$vroom(base64url$base64_urldecode(query[["access"]]),
                                  show_col_types = FALSE)
                      )
        dataset$selected <- dataset$data
      }
    })

    # observeEvent(dataset$data, {
    #   updateVarSelectInput(
    #     session,
    #     "variables",
    #     data = dataset$data)
    # })

    output$describe_all <- DT$renderDT({
      data <- req(dataset$selected)

      # if(!is.null(dataset$data))
        show_DT_table(dataset$selected |> explore$describe(out = "text"))
    }) # render summary

    updated_data <- update_variables_server(
      id = "update",
      data = reactive(dataset$data),
      height = "300px"
    ) # update and select variables

    observeEvent(updated_data(), {
      dataset$selected <- updated_data()
    })

    output$view <- DT$renderDT({
      # if (length(input$variables) == 0)
      #   dataset$selected <- dataset$data
      # else
      #   dataset$selected <- dataset$data %>% dplyr$select(!!!input$variables)

      data <- req(dataset$selected)
      # if(!is.null(dataset$selected))
        show_DT_table(data)
    }) # render data table

    return(reactive(dataset$selected))
  })
}
