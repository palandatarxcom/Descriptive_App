box::use(
  shiny = shiny[...]
)

box::use(
  dataview = app/view/page_dataview[dataview_ui, dataview_server],
  varexplore = app/view/page_varexplore[varexplore_ui, varexplore_server],
  filtering = app/view/page_filtering[filtering_ui, filtering_server]
)

#
# for local testing only:
# - encode the local sample data, in command line: echo "<location>" | tr -d "\n" | base64
# - put the encode string in the URL: http://127.0.0.1:7382/?access=<encode_location>
#
# encoded sample data file location: L1VzZXJzL2xpbnlvbmcvRG93bmxvYWRzL3RhYmxlMS5jc3Y=
# original sample data file: /Users/linyong/Downloads/table1.csv
#
## ---------------------------
##
## Script name: main.R
##
## Purpose of script: main entry of the app
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
  datamods = datamods[set_i18n,...]
)

datamods$set_i18n("cn")

#' @export
ui <- function(id) {
  ns <- NS(id)
  page1 <- dataview_ui(ns("dataview"))
  page2 <- filtering_ui(ns("filtering"))
  page3 <- varexplore_ui(ns("varselection"))
  # page4 <- mod_subgroup_ui("subgroup")
  # page5 <- mod_gentableone_ui("gentableone")

  tagList(
    tags$link(rel="stylesheet", href="static/css/styles.css", type="text/css"),
    tags$link(rel="stylesheet", href="static/css/yeti.css", type="text/css"),

    navbarPage(
      "描述性分析（Table One）",
      tabPanel("数据集浏览和调整", page1),
      tabPanel("筛选行记录", page2),
      tabPanel("分析变量关系", page3),
      tabPanel("调整亚组", "调整亚组"),
      tabPanel("生成基线表", "生成基线表"),
      navbarMenu(
        "more",
        tabPanel("panel 4a", "four-a"),
        tabPanel("panel 4a", "four-a"),
        tabPanel("panel 4a", "four-a"),
      ),
    ),
  )
}

#' @export
server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      raw_dataset <- dataview_server("dataview") #select variables
      filtered_data <- filtering_server("filtering", dat=raw_dataset) # filtering
      varexplore_server("varselection", dat=filtered_data) #explore the variables
      # mod_subgroup_server("subgroup")
      # mod_gentableone_server("gentableone")
  })
}
