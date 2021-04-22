downloadCAMELS <- function(dir, unzip=TRUE, meta=TRUE, daymet=TRUE,
                           maurer=TRUE, NLDAS=TRUE, shapefiles=TRUE, ...) {
  #---- SETUP ----------------------------------------------------------------#
  #-- Hopefully this doesn't change often
  webdir <- 'http://ral.ucar.edu/sites/default/files/public/product-tool/camels-catchment-attributes-and-meteorology-for-large-sample-studies-dataset-downloads/'

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
  doDownload <- c(meta, daymet, maurer, NLDAS, shapefiles)

  #---- ERROR CHECKING -------------------------------------------------------#

  # Make sure directory exists
  if (!dir.exists(dir)) {
    stop('Directory passed does not exist!')
  }

  #---- DOWNLOADING ----------------------------------------------------------#
  #-- Do the downloads
  for (i in 1:length(webFiles)) {

    #-- Did the user want to download this?
    if (doDownload[i] == TRUE) {
      #-- Report what we're doing
      print(paste('Downloading CAMELS',webFileNames[i]))

      #-- Download
      download.file(url = paste0(webdir, webFiles[i]),
                    destfile = paste0(dir,"/",webFiles[i]),
                    method = 'auto', ...)

      #-- Unzip, if requested
      if (unzip == TRUE) {
        unzip(zipfile = paste0(dir,'/',webFiles[i]),
              exdir = dir)
      }
    }
  }

}
