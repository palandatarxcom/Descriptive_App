## ---------------------------
##
## Script name: page_varselection.R
##
## Purpose of script: display selected variables in pairs
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
  dplyr = dplyr[select, ...],
  GGally = GGally[ggpairs, ...],
  utils[str, ...]
)

global_data <- reactiveVal(NULL)

#' @export
varselection_ui <- function(id) {
  ns <- NS(id)
  tagList(
    titlePanel("选择变量"),
    sidebarLayout(
      sidebarPanel(
        # actionButton(ns("go"), "Get variables"),
        varSelectInput(ns("variables"), "变量:", NULL, multiple = TRUE)
      ),

      mainPanel(
        verbatimTextOutput(ns("summary")),
        plotOutput(ns("ggpairs"))
      )
    )
  )
}

#' @export
varselection_server <- function(id, dat) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    dataset <- reactiveValues()

    # observeEvent(input$go, {
    #   message("go")
    #   updateVarSelectInput(
    #     session,
    #     "variables",
    #     data = dat())
    # })

    observeEvent(dat(), {
        updateVarSelectInput(
          session,
          "variables",
          data = dat())
    })

    output$summary <- renderPrint(str(dat()))

    output$ggpairs <- renderPlot({
      if (length(input$variables) == 0)
        dataset$selected <- dat()
      else
        dataset$selected <- dat() %>% dplyr$select(!!!input$variables)

      ggpairs(dataset$selected)
    })

    return(reactive(dataset$selected))
  })
}
