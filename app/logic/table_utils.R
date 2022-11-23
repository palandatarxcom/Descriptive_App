## ---------------------------
##
## Script name: table_utils.R
##
## Purpose of script: helper function for table
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
  dplyr = dplyr[mutate_if, ...],
  DT = DT[datatable, ...],
)


#' @export
show_DT_table <- function(dat) {
  DT$datatable(data = dat,
                rownames = FALSE,
                selection = "none",
                options = list(pageLength = 15, scrollX = TRUE))
}

#' @export
# prep a new data.frame with more diverse data types
preprocess_df <- function(df) {
  df |>
    mutate_if(~is.character(.) && length(unique(.)) <= 25, as.factor) |>
    mutate_if(~is.numeric(.) && all(Filter(Negate(is.na), .) %% 1 == 0), as.integer)
}
