#' Basin Forcing File Reader
#'
#' Returns named list with four items:
#'  - data (dataframe of forcing data)
#'  - gaugeLatitude
#'  - gaugeElevation
#'  - basinArea
#'
#' @param filename filename/path of basin forcing text file
#' @param altheader vector string to be used as column names (optional)
#' @param dropDateInts T/F to drop original integer date columns after
#'                     conversion to date format (default T)
#'
#' @author Leland Scantlebury
#'
#' @return list
#' @export read.basinForcing
#'
#' @examples
#' folder <- 'basin_dataset_public_v1p2/basin_mean_forcing/maurer/11/'
#' filename <- paste0(folder, '07197000_lump_maurer_forcing_leap.txt')
#' bforce <- read.basinForcing(filename)
read.basinForcing <- function(filename, altheader=NULL, dropDateInts=TRUE) {
  if (is.null(altheader)) {
    # Provide header
    lumpheader <- c('year','month','day','hour','day_length_s.day', 'precip_mm.day',
                    'shortwave_rad_W.m2', 'SWE_mm', 'temp_max_C', 'temp_min_C',
                    'vapor_pressure_Pa')
  } else {
    lumpheader <- altheader
  }

  # Assemble Classes
  classes <- c(rep("integer",4),rep("numeric",7))

  # Get info from first three lines
  f <- file(filename, "r")
  gaugeLatitude <- as.numeric(readLines(f, n=1))
  gaugeElevation <- as.numeric(readLines(f, n=1))
  basinArea <- as.numeric(readLines(f, n=1))
  close(f)

  # Read text file (tab delimited)
  basinforcing <- read.table(file = filename,
                             skip = 4,
                             colClasses = classes,
                             col.names = lumpheader,
                             header = F,
                             stringsAsFactors = F)

  # Convert to R-friendly date format
  basinforcing$date <- paste(basinforcing$year, basinforcing$month, basinforcing$day, sep='-')
  basinforcing$date <- as.Date(basinforcing$date)

  # Subset to rearrange and drop old date data (unless asked not to)
  dfsub <- lumpheader
  if (dropDateInts == T) {dfsub <- dfsub[5:length(dfsub)]}
  dfsub <- c('date', dfsub)
  basinforcing <- basinforcing[,dfsub]

  # Assemble and return object
  return(list(data = basinforcing,
              gaugeLatitude = gaugeLatitude,
              gaugeElevation = gaugeElevation,
              basinArea = basinArea))

}
