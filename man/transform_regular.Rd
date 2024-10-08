% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_data.R
\name{transform_regular}
\alias{transform_regular}
\title{Adjusts data frame to corporaexplorer format}
\usage{
transform_regular(df, tile_length_range = c(1, 10))
}
\arguments{
\item{df}{Data frame with text column (character),
Date column (Date) (if date based corpus),
and
optionally other
columns.}

\item{tile_length_range}{Numeric vector of length two.
Fine-tune the tile lengths in document wall
and day corpus view. Tile length is calculated by
\code{scales::rescale(nchar(dataset[[text_column]]),
to = tile_length_range,
from = c(0, max(.)))}
Default is \code{c(1, 10)}.}
}
\value{
A tibble ("data_dok")
}
\description{
Adjusts data frame to corporaexplorer format
}
\keyword{internal}
