read.basinHRUList <- function(filename, fullpaths=TRUE) {

  header <- c('filename', 'HRUArea')

  basinHRUList <- read.table(file = filename,
                             header = F,
                             skip = 1,
                             col.names = header,
                             stringsAsFactors = F)

  # Expand file path relative to input path, if requested
  if (fullpaths == TRUE) {
    basinHRUList$filename <- paste0(dirname(filename), '/', basinHRUList$filename)
  }

  return(basinHRUList)
}
