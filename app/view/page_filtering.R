## ---------------------------
##
## Script name: page_filtering.R
##
## Purpose of script: filter the dataset with given attributes
##
## Author: Lin Yong
##
## Date Created: 2022-11-11
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
  DT = DT[datatable, DTOutput, ...],
  dplyr = dplyr[select, ...],
  shiny = shiny[...],
  shinyDataFilter = shinyDataFilter[shiny_data_filter, shiny_data_filter_ui, ...],
  utils = utils[capture.output, ...]
)


#' @export
filtering_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::h2("筛选数据"),
    fluidRow(
      column(8,
        div(id = "dv_statistic",
           wellPanel(
             dataTableOutput(ns("data_summary")),
           )
        ),

        verbatimTextOutput(ns("data_filter_code"))
      ),
      column(4, shiny_data_filter_ui(ns("data_filter")))
    )
  )
}

#' @export
filtering_server <- function(id, dat) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    filtered_data <- callModule(
      shiny_data_filter,
      "data_filter",
      data = dat,
      # choices = ,
      verbose = FALSE
    )

    output$data_filter_code <- renderPrint({
      cat(gsub("%>%", "%>% \n ",
               gsub("\\s{2,}", " ",
                    paste0(
                      capture.output(attr(filtered_data(), "code")),
                      collapse = " "))
      ))
    })

    output$data_summary <- renderDataTable(
      {
      filtered_data()
      },
      options = list(
        scrollX = TRUE,
        pageLength = 10
      )
    )

    return(filtered_data)
  })
}
