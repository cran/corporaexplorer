
# Setting up data and constants -------------------------------------------

abc <- shiny::getShinyOption("corporaexplorer_download_data")

# Ugly hack because of testthat's "dry run" with empty data before testing
if(is.null(abc)) {
    abc <-
        corporaexplorer::prepare_data("testthat has a 'dry run' of sorts, resulting in weird behaviour.",
                                      corpus_name = "Not supposed to ever be launched as app")
}

source("./global/backwards_compatibility.R", local = TRUE)

if (class(abc) == "corporaexplorerobject") {
  INFO_COLUMNS <- abc$columns_for_info
  DATE_BASED_CORPUS <- abc$date_based_corpus

  # Regarding titles for html report
  contains_grouping_variable <-
      !is.null(abc$original_data$grouping_variable)
  if (contains_grouping_variable == TRUE) {
    GROUPING_VARIABLE <-
        abc$original_data$grouping_variable
  } else {
       GROUPING_VARIABLE <- NA
  }

  abc <- abc$original_data$data_dok
  abc$Text_column_ <- abc$Text_original_case
}

my_colours <-
  rep(c("red", "blue", "green", "purple", "orange", "gray"), 10)

MAX_DOCS_FOR_HTML <-   shiny::getShinyOption("corporaexplorer_download_max_html")


