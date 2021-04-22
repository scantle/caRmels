#' Read CAMELS attribute file (see N. Addor et al., 2017)
#'
#' Generic text file reader for the CAMELS attribute files
#'
#' @param filename filename/path of basin forcing text file
#' @param altheader vector string to be used as custom column names (optional)
#' @param subset list of basins to subset and return
#'
#' @author Leland Scantlebury
#'
#' @return dataframe
#' @export read.camelsAttr
#'
#' @examples
#' geol <- read.camelsAttr(filename = 'camels_geol.txt')
read.camelsAttr <- function(filename, altheader=NULL, subset=NULL) {

  if (!is.null(altheader)) {
    # Use altheader for read if passed
    attr <- read.table(file = filename,
                       sep = ';',
                       header = F,
                       skip = 1,
                       col.names = altheader,
                       quote = "",
                       stringsAsFactors = F)
  } else {
    # Use header in file
    attr <- read.table(file = filename,
                       sep = ';',
                       header = T,
                       quote = "",
                       stringsAsFactors = F)
  }

  if (!is.null(subset)) {
    # Subset by basin id
    attr <- attr[attr[[1]] %in% subset]
  }

  return(attr)

}
