#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(DT)
library(explore)

source("mod_dataview.R")
source("mod_varselection.R")
source("mod_filtering.R")
source("mod_subgroup.R")
source("mod_gentableone.R")

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

#sample dataset path: L1VzZXJzL2xpbnlvbmcvRG93bmxvYWRzL2xpbmVsaXN0X2NsZWFuZWQucmRz
#"/Users/linyong/Downloads/linelist_cleaned.rds"
app_server <- function(input, output, session) {
  dataset <- mod_dataview_server("dataview")
  mod_varselection_server("varselection", dat=dataset)
  mod_filtering_server("filtering")
  mod_subgroup_server("subgroup")
  mod_gentableone_server("gentableone")
}

# Run the application
shinyApp(ui = app_ui, server = app_server)
