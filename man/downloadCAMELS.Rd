% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/downloadCAMELS.R
\name{downloadCAMELS}
\alias{downloadCAMELS}
\title{Download CAMELS files}
\usage{
downloadCAMELS(
  dir,
  unzip = FALSE,
  primary_files = TRUE,
  daymet_output = TRUE,
  maurer_output = TRUE,
  NLDAS_output = TRUE,
  shapefiles = TRUE,
  timeout = 99999,
  ...
)
}
\arguments{
\item{dir}{Target directory to download files to}

\item{unzip}{T/F if downloaded files should be unzipped}

\item{primary_files}{T/F download basin forcing data for all three
meteorology products, observed streamflow, basin metadata, readme files,
and basin shapefiles}

\item{daymet_output}{T/F download comparison model output files calibrated
using daymet forcings}

\item{maurer_output}{T/F download comparison model output files calibrated
using maurer forcings}

\item{NLDAS_output}{T/F download comparison model output files calibrated
using NLDAS forcings}

\item{shapefiles}{T/F download original basin boundary shapefiles}

\item{timeout}{Max time allowed for download. Default: 99999 seconds (the
files are large)}

\item{...}{Additional arguments passed to \code{\link[utils]{download.file}}}
}
\description{
Function does not download all available files including basin information,
model output, and CAMELS documentation.
See \link{https://gdex.ucar.edu/dataset/camels.html}.
}
\details{
Note: Unzipping often fails, R unzip function is not very robust.
}
\examples{
\dontrun{
downloadCAMELS('../CAMELS/', unzip=FALSE)
}
}
