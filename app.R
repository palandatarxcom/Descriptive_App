#
# Descriptive analysis in Shiny app.
#

library(shiny)
library(dplyr)
library(DT)
library(explore)

# Define UI for application that draws a histogram
app_ui <- function(request) {
  page1 <- mod_dataview_ui("dataview")
  page2 <- mod_varselection_ui("varselection")
  page3 <- mod_filtering_ui("filtering")
  page4 <- mod_subgroup_ui("subgroup")
  page5 <- mod_gentableone_ui("gentableone")

  tagList(
    navbarPage(
      "描述性分析（Table One）",
      tabPanel("数据浏览", page1),
      tabPanel("选择字段", page2),
      tabPanel("筛选字段", page3),
      tabPanel("调整亚组", page4),
      tabPanel("生成基线表", page5),
      navbarMenu(
        "more",
        tabPanel("panel 4a", "four-a"),
        tabPanel("panel 4a", "four-a"),
        tabPanel("panel 4a", "four-a"),
      ),
    ),
  )
}

#
# for local testing only:
# - encode the local sample data, in command line: echo "<location>" | tr -d "\n" | base64
# - put the encode string in the URL: http://127.0.0.1:7382/?access=<encode_location>
#
# encoded sample data file location: L1VzZXJzL2xpbnlvbmcvRG93bmxvYWRzL3RhYmxlMS5jc3Y=
# original sample data file: /Users/linyong/Downloads/table1.csv
#
app_server <- function(input, output, session) {
  raw_dataset <- mod_dataview_server("dataview")
  varselected_dataset <- mod_varselection_server("varselection", dat=raw_dataset)
  mod_filtering_server("filtering", dat=varselected_dataset)
  mod_subgroup_server("subgroup")
  mod_gentableone_server("gentableone")
}

# Run the application
shinyApp(ui = app_ui, server = app_server)
