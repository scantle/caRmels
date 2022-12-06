#' Download CAMELS files
#'
#' Function does not download all available files including basin information,
#' model output, and CAMELS documentation.
#' See \link{https://gdex.ucar.edu/dataset/camels.html}.
#'
#' Note: Unzipping often fails, R unzip function is not very robust.
#'
#' @param dir Target directory to download files to
#' @param unzip T/F if downloaded files should be unzipped
#' @param primary_files T/F download basin forcing data for all three
#' meteorology products, observed streamflow, basin metadata, readme files,
#' and basin shapefiles
#' @param daymet_output T/F download comparison model output files calibrated
#' using daymet forcings
#' @param maurer_output T/F download comparison model output files calibrated
#' using maurer forcings
#' @param NLDAS_output T/F download comparison model output files calibrated
#' using NLDAS forcings
#' @param shapefiles T/F download original basin boundary shapefiles
#' @param timeout Max time allowed for download. Default: 99999 seconds (the
#' files are large)
#' @param ... Additional arguments passed to \code{\link[utils]{download.file}}
#'
#' @export
#'
#' @examples
#' \dontrun{
#' downloadCAMELS('../CAMELS/', unzip=FALSE)
#' }
downloadCAMELS <- function(dir, unzip=FALSE, primary_files=TRUE, daymet_output=TRUE,
                           maurer_output=TRUE, NLDAS_output=TRUE, shapefiles=TRUE,
                           timeout=99999, ...) {
  #---- SETUP ----------------------------------------------------------------#
  #-- Hopefully this doesn't change often
  # Dec 2022 It changed and someone was nice enough to let me know :)
  webdir <- 'https://gdex.ucar.edu/dataset/camels/file/'

  #-- Setup items
  webFileNames <- c('Observed meteorology and observered flow meta data',
                    'Daymet forced model output',
                    'Maurer forced model output',
                    'NLDAS forced model output',
                    'Full resolution basin shapefile')
  webFiles <- c('basin_timeseries_v1p2_metForcing_obsFlow.zip',
                'basin_timeseries_v1p2_modelOutput_daymet.zip',
                'basin_timeseries_v1p2_modelOutput_maurer.zip',
                'basin_timeseries_v1p2_modelOutput_nldas.zip' ,
                'basin_set_full_res.zip')

  #-- Create bool list for looping
  doDownload <- c(primary_files, daymet_output, maurer_output, NLDAS_output, shapefiles)

  #---- ERROR CHECKING -------------------------------------------------------#

  # Make sure directory exists
  if (!dir.exists(dir)) {
    stop('Directory passed does not exist!')
  }

  #---- DOWNLOADING ----------------------------------------------------------#
  #-- Do the downloads
  options(timeout=timeout)
  for (i in 1:length(webFiles)) {

    #-- Did the user want to download this?
    if (doDownload[i] == TRUE) {
      #-- Report what we're doing
      message(paste('Downloading CAMELS',webFileNames[i]))

      #-- Download
      download.file(url = paste0(webdir, webFiles[i]),
                    destfile = paste0(dir,"/",webFiles[i]),
                    method = 'auto', ...)

      #-- Unzip, if requested
      if (unzip == TRUE) {
        message('Unzipping file: ',webfiles[i])
        unzip(zipfile = paste0(dir,'/',webFiles[i]),
              exdir = dir)
      }
    }
  }

}
