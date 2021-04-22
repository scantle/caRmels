#' Import CAMELS HRU Daymet forcings
#'
#' Reads all (unless subset passed) of the HRU forcing files. Returns list of
#' lists - outer most list index is the basin id, which give access to a list
#' indexed by the basin's HRU ids. The HRU list contains four slots:
#'  - data (dataframe of HRU forcing data)
#'  - gaugeLatitude
#'  - HRUElevation
#'  - HRUArea
#'
#' @param folder name/path HRU forcing folder (e.g., 'hru_forcing')
#' @param subset string vector of basin ids to import (optional, otherwise imports all)
#' @param verbose T/F to determine whether to print importing status
#' @param ... optional arguments passed to read.HRUForcing()
#'
#' @author Leland Scantlebury
#'
#' @return list of lists (of lists)
#' @export importHRUs
#'
#'
#' @examples
#' basinSubset <- c('01013500','10259200','14137000',
#'                  '08198500','03592718','03604000')
#' HRUForcings <- importHRUs(folder = 'basin_dataset_public_v1p2/hru_forcing/daymet/',
#'                           subset = basinSubset )
importHRUs <- function(folder, subset=NULL, verbose=TRUE, ...) {

  #---------------------------------------------------------------------------#
  #-- Get all HRU forcing files
  HRUFiles <- list.files(folder,
                         recursive = T,
                         pattern = '_cida_forcing_leap.txt',
                         full.names = F)

  #-- Limit to subset if applicable
  if (!is.null(subset)) {
    newlist <- c()
    for (i in 1:length(subset)) {
      newlist <- append(newlist, HRUFiles[grep(subset[i], HRUFiles)])
    }
    HRUFiles <- newlist
  }

  #---------------------------------------------------------------------------#
  #-- Assemble list of Basins (if subset is not present)
  if (!is.null(subset)) {
    # Basin ID is the first 8 digits
    basinList <- unique(strtrim(basename(HRUFiles),8))
  } else {
    basinList <- subset
  }

  #-- Loop over basins importing HRUs
  if (verbose) {print(paste('Importing forcing data for', length(HRUFiles),
                            'HRUs from', length(basinList), 'Basins'))}

  BasinHRUForcings <- sapply(basinList, USE.NAMES = T, FUN=function(bID) {
    if (verbose) {print(paste('Reading HRUs from Basin', bID))}
    # Get HRU file list and then get names
    hlist <- HRUFiles[grep(bID, HRUFiles)]
    hnames <- lapply(hlist, function(x) {strsplit(x, '_')[[1]][3]})

    HRUForcings <- lapply(hlist, FUN=function(hfile){
      #if (verbose) {print(paste(' - HRU', basename(hfile)))}  # Kinda annoying
      # Read the HRU
      read.HRUForcing(paste0(folder,'/',hfile), ...)
    })
    # Add names so user can access HRUs easily
    names(HRUForcings) <- hnames
    return(HRUForcings)

  })

  return(BasinHRUForcings)
}
