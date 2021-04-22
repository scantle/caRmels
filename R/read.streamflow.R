#' Read CAMELS USGS Streamflow File
#'
#' @param filename filename/path of HRU forcing text file
#' @param altheader vector string to be used as column names (optional)
#' @param dropDateInts T/F to drop original integer date columns after
#'                     conversion to date format (default T)
#' @param convertNA T/F convert NA values (-999) to R-friendly NA
#'
#' @author Leland Scantlebury
#'
#' @return dataframe
#' @export read.streamflow
#'
#' @examples
#' folder <- 'basin_dataset_public_v1p2/usgs_streamflow/01/'
#' filename <- paste0(folder, '01013500_streamflow_qc.txt')
#' mystream <- read.streamflow(filename)
read.streamflow <- function(filename, altheader=FALSE, dropDateInts=TRUE, convertNA=TRUE) {
  if (altheader == FALSE) {
    # Provide "sanitized" Header
    streamflowHeader <- c('gage_ID', 'year', 'month', 'day', 'streamflow_cfs', 'QC_flag')
  } else {
    streamflowHeader <- altheader
  }

  # Assemble Classes
  classes <- c(rep("integer",4),"numeric","character")

  # Read text file (space delimited)
  streamflow <- read.table(file = filename,
                           colClasses = classes,
                           col.names = streamflowHeader,
                           header = F,
                           stringsAsFactors = F)

  #-- NA Handling
  if (convertNA) {
    streamflow[streamflow[[5]] <= -999,5] <- NA
  }

  # Convert to R-friendly date format
  streamflow$date <- paste(streamflow$year, streamflow$month, streamflow$day, sep='-')
  streamflow$date <- as.Date(streamflow$date)

  # Subset to rearrange and drop old date data (unless asked not to)
  dfsub <- streamflowHeader
  if (dropDateInts == T) {dfsub <- dfsub[5:length(dfsub)]}
  dfsub <- c('date', dfsub)
  streamflow <- streamflow[,dfsub]

  return(streamflow)
}
