#-----------------------------------------------------------------------------#
#' Read CAMELS river gauge information file.
#'
#' A file reader for the CAMELS river gauge information file. Provides
#' correct header (as of June 2019) and uses read.table with specific parameters
#' to ensure the file is read correctly.
#'
#' @param filename filepath/name of CAMELS gauge_information.txt file
#' @param altheader alternative header for applying to DataFrame columns
#'
#' @return DataFrame of river gauge info
#' @author Leland Scantlebury
#' @export read.gaugeInfo
#'
#' @keywords CAMELS river gage gauge
#' @examples
#'   gauges <- read.gaugeInfo('basin_dataset_public_v1p2/basin_metadata/gauge_information.txt')
read.gaugeInfo <- function(filename, altheader=FALSE) {

  if (altheader == FALSE) {
    # Provide "sanitized" Header
    gaugeInfoHeader <- c('basin_HUC', 'gage_ID', 'gage_name', 'lat', 'long', 'drainage_area_km2')
  } else {
    gaugeInfoHeader <- altheader
  }

  # Assemble Classes
  classes <- c("integer", "character", "character", "numeric", "numeric", "numeric")

  # Read text file (tab delimited, mostly, at least this version)
  gaugeInfo <- read.table(file = filename,
                          colClasses = classes,
                          sep = '\t',
                          col.names = gaugeInfoHeader,
                          header = F,
                          skip = 1,
                          stringsAsFactors = F,
                          quote = "")
  return(gaugeInfo)
}

#-----------------------------------------------------------------------------#
# Alt spelling (the CAMELS files are inconsistent themselves)
#' Read CAMELS river gage information file.
#'
#' Alternative spelling edition of read.gaugeInfo()
#'
#' @param filename filepath/name of CAMELS gauge_information.txt file
#' @param altheader alternative header for applying to DataFrame columns
#'
#' @return DataFrame of river gauge info
#' @author Leland Scantlebury
#' @export read.gaugeInfo
#'
#' @keywords CAMELS river gage gauge
#' @examples
#'   gages <- read.gageInfo('basin_dataset_public_v1p2/basin_metadata/gauge_information.txt')
read.gageInfo <- function(filename, altheader=FALSE) {

  return(read.gaugeInfo(filename, altheader))
}

#-----------------------------------------------------------------------------#
