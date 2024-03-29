% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/importBasinForcings.R
\name{importBasinForcings}
\alias{importBasinForcings}
\title{Import CAMELS basin forcings}
\usage{
importBasinForcings(folder, dataset, subset = NULL, verbose = TRUE, ...)
}
\arguments{
\item{folder}{name/path basin forcing folder (e.g., 'basin_mean_forcing')}

\item{dataset}{string of dataset name, one of 'DAYMET', 'MAURER', or 'NLDAS'}

\item{subset}{string vector of basin ids to import (optional, otherwise imports all)}

\item{verbose}{T/F to determine whether to print importing status}

\item{...}{optional arguments passed to read.basinForcing()}
}
\value{
list of lists
}
\description{
Reads all (unless subset passed) of the basin forcing files for a given
dataset (Daymet, Maurer, or NLDAS). Returns list of lists (named by
basin id) with four sub items:
 - data (dataframe of forcing data)
 - gaugeLatitude
 - gaugeElevation
 - basinArea
}
\examples{
basinSubset <- c('01013500','10259200','14137000',
                 '08198500','03592718','03604000')
daymetForcings <- importBasinForcings('basin_dataset_public_v1p2/basin_mean_forcing/daymet',
                                             dataset = 'daymet', subset=basinSubset)

}
\author{
Leland Scantlebury
}
