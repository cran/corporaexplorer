output$time_filtering_ui <- renderUI({

  if (DATE_BASED_CORPUS == TRUE) {

    shiny::tagList(
      shinyWidgets::radioGroupButtons(
        inputId = "years_or_dates",
        label = NULL,
        choices = c("Year range", "Date range"),
        justified = TRUE,
        size = "sm"
      ),

      shiny::conditionalPanel(
        condition = "input.years_or_dates == 'Year range'",
        sliderInput(
          "date_slider",
          label = NULL,
          min = min(abc$Year_),
          max = max(abc$Year_),
          value = range(abc$Year_),
          sep = ""
        )
      ),

      shiny::conditionalPanel(
        condition = "input.years_or_dates == 'Date range'",
        shiny::dateRangeInput(
          "date_calendar",
          label = NULL,
          weekstart = 1,
          start = min(abc$Date),
          end = max(abc$Date),
          min = min(abc$Date),
          max = max(abc$Date)
        )
      ),

      hr()
    )

  }

})
