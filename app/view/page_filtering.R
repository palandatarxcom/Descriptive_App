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
  shiny = shiny[...]
)

box::use(
  app/logic/table_utils[show_DT_table, ...]
)


#' @export
filtering_ui <- function(id) {
  ns <- NS(id)
  tagList(
    shiny::h2("Data Summary"),
    DT$DTOutput(ns("describe_all"))
  )
}

#' @export
filtering_server <- function(id, dat) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    output$describe_all <- DT$renderDT({
      show_DT_table(dat())
    }) # render summary
    return(dat)
  })
}
