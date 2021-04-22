#' Imports/combines CAMELS attribute files (see N. Addor et al., 2017)
#'
#' Reads in all CAMELS attribute text files and returns a data frame (or list)
#' of the data
#'
#' @param folder path/name of folder with CAMELS attribute text files
#' @param attrSubset string vector of attribute file types to import (e.g. 'soil')
#' @param returnList Bool, return list of data by file instead of data frame?
#'
#' @author Leland Scantlebury
#'
#' @return dataframe or list of dataframes
#' @export importAttributes
#'
#' @examples
#' basinPar <- importAttributes('camels_attributes_v2.0')
importAttributes <- function(folder, attrSubset=NULL, returnList=FALSE) {

  #---------------------------------------------------------------------------#
  #-- Get Attribute files
  attrPattern <- 'camels_[*].txt'
  attrFiles <- list.files(folder,
                          recursive = F,
                          pattern='camels_.*.txt',
                          full.names = F)
  # Subset if necessary
  if (!is.null(attrSubset)) {
    # It's a small list, we can just loop
    newList <- c()
    for (i in 1:length(attrFiles)) {
      # Hideous line to extract attr
      attr <- strsplit(sub('.txt', '', basename(attrFiles[i])), '_')[[1]][2]
      if (attr %in% attrSubset) { newList <- c(newList, attrFiles[i])}
    }
    if (length(newList) > 0) {attrFiles <- newList}
    else {stop('attrSubset contained no valid attribute names')}
  }

  #-- Order (personal preference)
  order <- c('name', 'topo')
  for (i in 1:length(order)) {
    fname <- paste0('camels_', order[i], '.txt')
    if (fname %in% attrFiles) {
      # Tricks are for R
      attrFiles <- append(attrFiles[-match(fname, attrFiles)], fname, i-1)
    }
  }

  #---------------------------------------------------------------------------#
  #-- Loop over files, combine by basinID
  basinAttr <- NULL
  basinList <- lapply(attrFiles, function(afile) {
    rfile <- read.camelsAttr(paste0(folder, '/', afile))
    if (is.null(basinAttr)) {
      basinAttr <<- rfile
    } else {
      basinAttr <<- merge(basinAttr, rfile, by='gauge_id')
    }
  })

  #---------------------------------------------------------------------------#
  if (returnList==TRUE) {
    # For now
    names(basinList) <- attrFiles
    return(basinList)
  } else {
    return(basinAttr)
  }
}
