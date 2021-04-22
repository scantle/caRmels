#' Import USGS Streamflow files
#'
#' Reads in all streamflow files within folders (unless subset is specified)
#' and returns a list of dataframes indexed by basin id of the stream gauge
#' data.
#'
#' @param folder name/path streamflow folder (e.g., 'usgs_streamflow')
#' @param subset string vector of basin ids to import (optional, otherwise imports all)
#' @param verbose T/F to determine whether to print importing status
#' @param ... optional arguments passed to read.streamflow()
#'
#' @author Leland Scantlebury
#'
#' @return list of dataframes
#' @export importStreamflows
#'
#' @examples
#' basinSubset <- c('01013500','10259200','14137000',
#'                  '08198500','03592718','03604000')
#' streamflows <- importStreamflows('basin_dataset_public_v1p2/usgs_streamflow',
#'                                  subset = basinSubset)
importStreamflows <- function(folder, subset=FALSE, verbose=TRUE, ...) {

  #---------------------------------------------------------------------------#
  #-- Get all streamflow files
  streamFiles <- list.files(folder,
                         recursive = T,
                         pattern = '_streamflow_qc.txt',
                         full.names = F)

  #-- Limit to subset if applicable
  if (subset[1] != FALSE) {
    newlist <- c()
    for (i in 1:length(subset)) {
      newlist <- append(newlist, streamFiles[grep(subset[i], streamFiles)])
    }
    streamFiles <- newlist
  }

  #---------------------------------------------------------------------------#
  #-- Loop over files
  if (verbose) {print(paste('Importing streamflow data for', length(streamFiles),
                            'gauges'))}

  streamflows <- lapply(streamFiles, FUN=function(sfile){

    if (verbose) {print(paste('Reading data from gauge',
                              strtrim(basename(sfile), 8)))}

    read.streamflow(paste0(folder, '/', sfile))
  })

  names(streamflows) <- strtrim(basename(streamFiles), 8)

  return(streamflows)

}
