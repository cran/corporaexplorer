#' Collecting search terms from user input
#'
#' @return Character vector.
collect_search_terms <- function() {
    terms <- c(
        shiny::isolate(input$search_text_1),
        shiny::isolate(input$search_text_2),
        shiny::isolate(input$search_text_3),
        shiny::isolate(input$search_text_4),
        shiny::isolate(input$search_text_5),
        shiny::isolate(input$search_text_6)
    )[seq_len(shiny::isolate(input$antall_linjer))] %>%
        (function(x)
            x <- x[x != ""]) #%>%
        # unique
    if(length(terms) == 0){
        terms <- ""
    }

    return(terms)
}

#' Collecting highlight terms from user input
#'
#' @return Character vector.
collect_highlight_terms <- function() {
    if (is.null(isolate(input$more_terms_button))) {
        # avgjørende at is.null-varianten kommer først i if-statementet!
        terms_highlight <- collect_search_terms()
    }   else if (isolate(input$more_terms_button == 'Yes')) {
        terms_highlight <- isolate(input$highlight_terms_area) %>%
            stringr::str_split("\n") %>%
            unlist %>%
            .[length(.) > 0]

        terms_highlight <-
            c(collect_search_terms(), terms_highlight[terms_highlight != ""])

    }
    terms_highlight <-
        terms_highlight[terms_highlight != ""]

    return(terms_highlight)
}

#' Collecting subset/filter terms from user input
#'
#' @return Character vector.
collect_subset_terms <- function() {
    if (input$subset_corpus == 'Yes') {
        terms_subset <- input$filter_text_area %>%
            stringr::str_split("\n") %>%
            unlist %>%
            .[length(.) > 0] %>%
            (function(x)
                x <- x[x != ""]) %>%
            unique

        return(terms_subset)
    }
}

#' Collecting threshold values for search terms
#'
#' If user input is "search_term--\d".
#'
#' @return Numeric vector with same length as search_terms vector. NA if no
#'   threshold.
collect_threshold_values <- function(chr_vector) {
    thresholds <- stringr::str_extract(chr_vector, "--\\d+($|--)") %>%
        stringr::str_replace_all("[^\\d]", "") %>%
        as.numeric()
    return(thresholds)
}

#' Collecting custom column in which to search for search terms
#'
#' If user input is "search_term--\D".
#'
#' @return Numeric vector with same length as search_terms vector. NA if no
#'   threshold.
collect_custom_column <- function(chr_vector) {
    column <- stringr::str_extract(chr_vector, "--[^\\d].*($|--)") %>%
        stringr::str_replace_all("(--\\d+|--)", "")
    if (isTRUE(column == loaded_data$text_column)) {
        column <- "Text_column_"
    }
    return(column)
}

#' Convert term to lower case, but keep upper case for special regex characters
#'
#' Note the use of Vectorize()
#'
#' @param pattern
#'
#' @return Pattern in lower case except the special characters,
#' which are still in upper case.
to_lower_except_special_characters <- Vectorize(function(pattern) {
    special_characters <- "(\\\\(B|S|N|c[A-Z]|W|D|u.{4}|x.{2}|Q|E))"
    if (stringr::str_detect(pattern, special_characters)) {
        pattern <-
            stringr::str_replace_all(pattern, special_characters, "--\\1--")
            pattern <- stringr::str_split(pattern, "--")[[1]]
        for (i in seq_along(pattern)) {
            if (!stringr::str_detect(pattern[i], special_characters)) {
                pattern[i] <- stringr::str_to_lower(pattern[i])
            }
        }
        pattern <- paste(pattern, collapse = "")
    } else {  # I.e. without special characters in pattern
        pattern <- stringr::str_to_lower(pattern)
    }
    return(pattern)
}, USE.NAMES = FALSE)

#' Convert terms to lower case if case insensitive search
#'
#' Except special regex characters
#'
#' @param terms Character vector
#'
#' @return Character vector
to_lower_if_case_insensitive_search <- function(terms) {
    if (search_arguments$case_sensitive == FALSE) {
        terms <- to_lower_except_special_characters(terms)
    }
    return(terms)
}

#' Removing "arguments" from search term
#'
#' @param terms Character vector.
#'
#' @return "Cleaned" character vector.
clean_terms <- function(terms) {
    if (length(terms) == 0) {
        return(terms)
    }
    terms <- stringr::str_replace(terms, "--.*$", "")

    return(terms)
}
