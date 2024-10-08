#' Document visualisation
#'
#' @param .text A data frame with 1 row including Text and Text_original_case columns
#' @param .pattern Character vector of arbitrary length of terms to chart in
#'     the plot
#' @param my_colours Vector of colours to highlight terms in the plot
#' @param case_sensitive Logical. Will the plot be based on case sensitive
#'     search?
#' @param tiles Integer. Number of tiles in each plot line.
#' @return Ggplot2 plot.
visualiser_dok <-
  function(.text,
           .pattern,
           case_sensitive,
           my_colours = MY_COLOURS,
           tiles = DOCUMENT_TILES) {

    # No document map for extremely short documents
    if (nchar(.text$Text_original_case) < (tiles * 2)) {
      return(NULL)
    }

    if (case_sensitive == FALSE) {
      .text <- .text$Text_column_
    } else if (case_sensitive == TRUE) {
      .text <- .text$Text_original_case
    }

    if (USE_ONLY_RE2 == TRUE) {
      locate_all_function <- re2::re2_locate_all
    } else if (USE_ONLY_RE2 == FALSE) {
      locate_all_function <- stringr::str_locate_all
    }

    # Tar et vilkårlig antall .pattern-elementer

    if (length(.pattern) == 0) {
      return(NULL)
    } else {
      word_loc <- list()
      sum_treff <- list()
      .pattern <- unique(.pattern)
      for (i in seq_along(.pattern)) {
        word_loc[[i]] <-
          locate_all_function(.text,
                                  .pattern[i]) %>% .[[1]] %>% .[, 1]
        sum_treff[[i]] <- length(word_loc[[i]])
      }

      names(word_loc) <-
        stringr::str_trunc(.pattern, 25) %>%
        paste(sum_treff[seq_along(.pattern)], sep = " | ")

      word_location <-
        locate_all_function(.text,
                                .pattern) %>%
        .[[1]] %>%
        .[, 1]

      lengde <- seq_len(nchar(.text))

      ost <- list()
      for (i in seq_along(.pattern)) {
        ost[[i]] <- as.integer(lengde %in% word_loc[[i]])
      }
      names(ost) <- names(word_loc)

      dok_tib <- tibble::tibble(Position = lengde)
      for (i in seq_along(.pattern)) {
        dok_tib <- cbind(dok_tib, ost[[i]])
      }
      colnames(dok_tib) <- c("Position", names(ost))

      dok_tib$dekadille <- with(
        dok_tib,
        cut(
          Position,
          breaks = stats::quantile(
            Position,
            probs = seq(0, 1, by = 1 / tiles),
            na.rm = TRUE
          ),
          include.lowest = TRUE,
          labels = 1:tiles
        )
      )

      dok_tib <- dok_tib %>%
        dplyr::select(-Position) %>%
        dplyr::group_by(dekadille) %>%

        dplyr::summarise_all(sum)
      # Plotting
      dok_tib_2 <- dplyr::group_by(dok_tib, dekadille) %>%
        tidyr::gather(ord, N,-dekadille)

      dok_tib_2$dekadille <- as.integer(dok_tib_2$dekadille)

      dok_tib_2 <-
        dok_tib_2[nrow(dok_tib_2):1,] # snur på hodet for å få "riktig" rekkefølge...

      dok_tib_2$ord <-
        factor(
          dok_tib_2$ord,
          levels = unique(dok_tib_2$ord),
          labels = unique(dok_tib_2$ord)
        )

      dok_tib_2$N[dok_tib_2$N == 0] <- NA

      # Function from colours_to_plot_and_legend.R
      gradient_colours <- rev(convert_colours_to_brewerpal_colours(my_colours[seq_along(.pattern)]))

      # Create manually defined colour for each tile
      dok_tib_2 <- dok_tib_2 %>%
        dplyr::ungroup() %>%
        dplyr::group_by(ord) %>%
        dplyr::mutate(
          scaled_N = if (all(is.na(N)))
            NA
          else
            round(scales::rescale(N, to = c(2, 9))),
          group_colour = gradient_colours[as.integer(as.factor(ord))],
          fill_colour = RColorBrewer::brewer.pal(name = group_colour[[1]], n = 9)[scaled_N]
        )

      dok_tib_2$fill_colour[is.na(dok_tib_2$fill_colour)] <-  "white"

      ggplot2::ggplot(dok_tib_2,
                        ggplot2::aes(
                          x = dekadille,
                          y = ord,
                          fill = fill_colour,
                          width = 1,
                          height = 1
                        )) +
        ggplot2::geom_tile(color = "black", linewidth = 0.1) +
        ggplot2::coord_fixed(ratio = 1, expand = FALSE) +
        ggplot2::labs(x = NULL, y = NULL) +
        ggplot2::scale_fill_identity() + # , values = c(0,0.1,1)) +
        ggplot2::scale_x_discrete(expand = c(0, 0)) +
        ggplot2::theme(axis.ticks.y = ggplot2::element_blank()) +
        ggplot2::theme(
          axis.title.x = ggplot2::element_blank(),
          axis.text.x = ggplot2::element_blank(),
          axis.ticks.x = ggplot2::element_blank()
        ) +
        ggplot2::theme(legend.position = "none")
    }
  }
