 if (length(search_arguments$terms_highlight) > 0) {
        output$dok_vis <- shiny::renderPlot({

                visualiser_dok(session_variables[[plot_mode$mode]][min_rad, ],
                               search_arguments$terms_highlight,
                               search_arguments$case_sensitive)
            
        }, height = function(x) {
            if (length(search_arguments$terms_highlight) == 0) {
                1
            } else{
                (25 + (length(search_arguments$terms_highlight) * 15))
            }
        })
    }
