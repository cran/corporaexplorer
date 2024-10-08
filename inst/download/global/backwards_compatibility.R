
# For K. Benoit, in case his review is on-going ---------------------------
# For objects from 0.4.0 --------------------------------------------------

if ("mnd_vert" %in% colnames(abc$original_data$data_365)) {
    abc$original_data$data_dok <-
        dplyr::rename(abc$original_data$data_dok,
               Text_original_case = Text_case)
}

if (is.null(abc$date_based_corpus)) {
    abc$date_based_corpus <- TRUE
}

# Before 0.8.6.9000 (custom text column) ----------------------------------

if (is.null(abc$text_column)) {
    abc$text_column <- "Text"
    abc$original_data$data_dok <- abc$original_data$data_dok %>%
        dplyr::rename(Text_column_ = Text,
                      Year_ = Year)
    abc$original_data$data_365 <- abc$original_data$data_365 %>%
        dplyr::rename(Year_ = Year)
}
