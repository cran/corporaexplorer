
# For K. Benoit, in case his review is on-going ---------------------------
# For objects from 0.4.0 --------------------------------------------------

if ("mnd_vert" %in% colnames(loaded_data$original_data$data_365)) {
    loaded_data$original_data$data_dok <-
        dplyr::rename(loaded_data$original_data$data_dok,
               Tile_length = wc,
               cx_ID = id,
               Text_original_case = Text_case)

    loaded_data$original_data$data_365 <-
        dplyr::rename(loaded_data$original_data$data_365,
                      Invisible_fake_date = cx_ID)

    loaded_data$original_data$data_365$Invisible_fake_date[loaded_data$original_data$data_365$Invisible_fake_date != 0] <- -1
    loaded_data$original_data$data_365$Invisible_fake_date[loaded_data$original_data$data_365$Invisible_fake_date == 0] <- 1
    loaded_data$original_data$data_365$Invisible_fake_date[loaded_data$original_data$data_365$Invisible_fake_date == -1] <- 0
    loaded_data$original_data$data_365$Invisible_fake_date <-
        as.logical(loaded_data$original_data$data_365$Invisible_fake_date)

    loaded_data$original_data$data_365 <-
        dplyr::rename(loaded_data$original_data$data_365,
               Tile_length = wc,
               cx_ID = id,
               Day_without_docs = empty)

    loaded_data$original_data$data_365 <-
        dplyr::select(loaded_data$original_data$data_365,
                      -No., -Week_n, -mnd_vert, -mnd_hor, -Month_n, -Yearday_n)
}

if (is.null(loaded_data$date_based_corpus)) {
    loaded_data$date_based_corpus <- TRUE
}

# Before 0.8.6.9000 (custom text column) ----------------------------------

if (is.null(loaded_data$text_column)) {
    loaded_data$text_column <- "Text"
    loaded_data$original_data$data_dok <- loaded_data$original_data$data_dok %>%
        dplyr::rename(Text_column_ = Text,
                      Year_ = Year)
    loaded_data$original_data$data_365 <- loaded_data$original_data$data_365 %>%
        dplyr::rename(Year_ = Year)
}
