#' Import CAMELS basin forcings
#'
#' Reads all (unless subset passed) of the basin forcing files for a given
#' dataset (Daymet, Maurer, or NLDAS). Returns list of lists (named by
#' basin id) with four sub items:
#'  - data (dataframe of forcing data)
#'  - gaugeLatitude
#'  - gaugeElevation
#'  - basinArea
#'
#' @param folder name/path basin forcing folder (e.g., 'basin_mean_forcing')
#' @param dataset string of dataset name, one of 'DAYMET', 'MAURER', or 'NLDAS'
#' @param subset string vector of basin ids to import (optional, otherwise imports all)
#' @param verbose T/F to determine whether to print importing status
#' @param ... optional arguments passed to read.basinForcing()
#'
#' @author Leland Scantlebury
#'
#' @return list of lists
#' @export importBasinForcings
#'
#' @examples
#' basinSubset <- c('01013500','10259200','14137000',
#'                  '08198500','03592718','03604000')
#' daymetForcings <- importBasinForcings('basin_dataset_public_v1p2/basin_mean_forcing/daymet',
#'                                              dataset = 'daymet', subset=basinSubset)
#'
importBasinForcings <- function(folder, dataset, subset=NULL, verbose=TRUE, ...) {

  #---------------------------------------------------------------------------#
  #-- Prepare based on dataset selected
  dataset <- toupper(dataset)
  if (dataset == 'DAYMET') {
    dsname <- 'cida'
  }
  else if (dataset == 'MAURER') {
    dsname <- 'maurer'
  }
  else if (dataset == 'NLDAS') {
    dsname <- 'nldas'
  }
  else {
    stop('Invalided dataset argument - must be one of DAYMET, MAURER, NLDAS')
  }

  #---------------------------------------------------------------------------#
  #-- Get all Basin forcing files
  dspattern <- paste0('lump_',dsname,'_forcing_leap.txt')
  basinFiles <- list.files(folder,
                          recursive = T,
                          pattern = dspattern,
                          full.names = F)

  #-- Limit to subset if applicable
  if (!is.null(subset)) {
    newlist <- c()
    for (i in 1:length(subset)) {
      newlist <- append(newlist, basinFiles[grep(subset[i], basinFiles)])
    }
    basinFiles <- newlist
  }

  #---------------------------------------------------------------------------#
  #-- Loop over basins importing files
  if (verbose) {print(paste('Importing lumped (mean) forcing data for',
                            length(basinFiles),'basins'))}

  lumpforce <- lapply(basinFiles, FUN=function(bfile){

    if (verbose) {print(paste('Reading data from basin',
                              strtrim(basename(bfile), 8)))}

    read.basinForcing(paste0(folder, '/', bfile), ...)
  })

  names(lumpforce) <- strtrim(basename(basinFiles), 8)

  return(lumpforce)

}
