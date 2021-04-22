#' Read CAMELS Basin HRU Forcing file
#'
#' Returns namedlist with four items:
#'  - data (dataframe of forcing data)
#'  - gaugeLatitude
#'  - HRUElevation
#'  - HRUArea
#'
#' @param filename filename/path of HRU forcing text file
#' @param altheader vector string to be used as column names (optional)
#' @param dropDateInts T/F to drop original integer date columns after
#'                     conversion to date format (default T)
#'
#' @author Leland Scantlebury
#'
#' @return list
#' @export read.HRUForcing
#'
#' @examples
#' myhru <- read.HRUForcing('hru_forcing/daymet/02/01333000_hru_04535_cida_forcing_leap.txt')
read.HRUForcing <- function(filename, altheader=FALSE, dropDateInts=TRUE) {
  if (altheader == FALSE) {
    # Provide "sanitized" Header
    HRUInfoHeader <- c('year','month','day','hour', 'day_length_s.day', 'precip_mm.day',
                       'shortwave_rad_W.m2', 'SWE_mm', 'temp_max_C', 'temp_min_C',
                       'vapor_pressure_Pa')
  } else {
    HRUInfoHeader <- altheader
  }

  # Glean info from filename
  fsplit <- strsplit(basename(filename), split = '_')
  basinID <- fsplit[[1]][1]
  HRUID <- fsplit[[1]][3]

  # Assemble Classes
  classes <- c(rep("integer", 4), rep("numeric", 7))

  # Get info from first three lines
  f <- file(filename, "r")
  gaugeLatitude <- as.numeric(readLines(f, n=1))
  HRUElevation <- as.numeric(readLines(f, n=1))
  HRUArea <- as.numeric(readLines(f, n=1))
  close(f)

  # Read text file (space delimited)
  HRUInfo <- read.table(file = filename,
                          colClasses = classes,
                          col.names = HRUInfoHeader,
                          header = F,
                          skip = 4,
                          stringsAsFactors = F)

  # Convert to R-friendly date format
  HRUInfo$date <- paste(HRUInfo$year, HRUInfo$month, HRUInfo$day, sep='-')
  HRUInfo$date <- as.Date(HRUInfo$date)

  # Subset to rearrange and drop old date data (unless asked not to)
  dfsub <- HRUInfoHeader
  if (dropDateInts == T) {dfsub <- dfsub[5:length(dfsub)]}
  dfsub <- c('date', dfsub)
  HRUInfo <- HRUInfo[,dfsub]

  # Add identifiers
  HRUInfo$basin_ID <- basinID
  HRUInfo$HRU_ID <- HRUID

  # Return a list of the data
  return(list(data = HRUInfo,
              gaugeLatitude = gaugeLatitude,
              HRUElevation = HRUElevation,
              HRUArea = HRUArea
              ))
}
