#' Read CAMELS basin Physical Characterists File
#'
#' @param filename filename/path of basin characterists file (e.g. 'basin_physical_characteristics.txt')
#' @param altheader vector string of custom column names to be used (optional)
#'
#' @author Leland Scantlebury
#'
#' @return dataframe
#' @export read.basinInfo
#'
#' @examples
#' folder <- 'basin_dataset_public_v1p2/basin_metadata/'
#' filename <- paste0(folder, 'basin_physical_characteristics.txt')
#' basinChar <- read.BasinInfo(filename)
read.basinInfo <- function(filename, altheader=FALSE) {

  if (altheader == FALSE) {
    # Provide "sanitized" Header
    basinInfoHeader <- c('basin_HUC', 'basin_ID', 'size_km2', 'elevation_m', 'slope_m.km', 'frac_forest')
  } else {
    basinInfoHeader <- altheader
  }

  # Assemble Classes
  classes <- c("integer", "character", "numeric", "numeric", "numeric", "numeric")

  # Read text file (space delimited)
  basinInfo <- read.table(file = filename,
                          colClasses = classes,
                          col.names = basinInfoHeader,
                          header = F,
                          skip = 1,
                          stringsAsFactors = F)
  return(basinInfo)
}
