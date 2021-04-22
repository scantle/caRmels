# caRmels: An R interface for the CAMELS Dataset
This R package adds some basic functionality to R for working with the Catchment Attributes and MEteorology for Large-sample Studies (CAMELS) dataset detailed in Newman et al. (2015) and Addor et al. (2017) and available at the [NCAR website](https://ral.ucar.edu/solutions/products/camels)

This package contains functions to download the datasets, but it is recommended you instead download them directly from the NCAR website.

## Package Installation
We suggest using the [devtools](https://cran.r-project.org/web/packages/devtools/index.html) package function `install_github` to install the package:
```r
library(devtools)
install_github('scantle/caRmels')

library(caRmels)
```

## Basic data reading/access functions
First, we assume the datasets (both the "meteorology, observed flow, meta data" and "attributes" zip files) have been downloaded and unzipped to a directory. For this example, we assume the folder path has been assigned to the variable `camels_dir`.

Basic information (folder, ID, name, lat, long, area) about the 671 gauges in the CAMELS dataset are stored in the gauge information text file. caRmels can read this in and store it in a DataFrame:
```r
gauge_info_path <- file.path(camels_dir,'basin_dataset_public_v1p2/basin_metadata/gauge_information.txt')
gauges <- read.gaugeInfo(gauge_info_path)
```

The full attributes can be read in using the `importAttributes(folder, attrSubset=NULL, returnList=FALSE)` function. This reads in and combines multiple text files to build one complete attribute DataFrame:
```r
basin_attr <- importAttributes(file.path(camels_dir,'camels_attributes_v2.0'))
```

Likely the primary use of this package will be accessing the basin forcing and streamflow datasets. It is possible to read in all the datasets at once but this can take up a prohibitive amount of memory. Here we assume a subset will be read in, used for all three forcing datasets.
```r
# Setup forcing folders
daymet_forcings <- file.path(camels_dir,'basin_dataset_public_v1p2/basin_mean_forcing/daymet')
maurer_forcings <- file.path(camels_dir,'basin_dataset_public_v1p2/basin_mean_forcing/maurer')
NLDAS_forcings  <- file.path(camels_dir,'basin_dataset_public_v1p2/basin_mean_forcing/NLDAS')

# Define basin id subsets (note: strings)
basinSubset <- c('01013500','10259200','14137000','08198500','03592718','03604000')

# Have to pass which forcing set is being read in as an argument to decode filenames
basinForcings_maurer <- importBasinForcings(maurer_forcings, dataset='maurer', subset=basinSubset)
basinForcings_daymet <- importBasinForcings(daymet_forcings, dataset = 'daymet', subset=basinSubset)
basinForcings_NLDAS  <- importBasinForcings(NLDAS_forcings, dataset = 'NLDAS', subset=basinSubset)

# Read in streamflow time series
flow_dir <- file.path(camels_dir,'basin_dataset_public_v1p2/usgs_streamflow')
streamflows <- importStreamflows(flow_dir, subset = basinSubset)
```

Each of these forcing reading functions returns a list, indexed by basin id, with gauge data, location, and area. For instance, for basin 10259200 (DEEP C NR PALM DESERT CA), we can access the daymet forcings from our read-in object:
```r
# Get daymet forcing for basin 10259200 - returns a DataFrame
palm_desert_daymet_data <- basinForcings_daymet$`10259200`$data

# Access location info, area
palm_desert_lat <- basinForcings_daymet$`10259200`$gaugeLatitude
palm_desert_long <- basinForcings_daymet$`10259200`$gaugeLongitude
palm_desert_area <- basinForcings_daymet$`10259200`$basinArea
```

The streamflows are also read in as a list. However, there is no additional data - the list slots just hold the streamflow time series:
```r
# Returns a DataFrame of time series of date, streamflow (cfs), and QC flags
palm_desert_flow <- streamflows$`10259200`
```
HRU-level forcings can be read in using the `importHRUs(folder, subset=NULL, verbose=TRUE, ...)` function.

## Example memory-efficient looping over basin subsets
The following code shows an example usage where the dataset is broken into 50 member "chunks" where data is read in, followed by a loop over each basin which. This inner basin loop could be used, for example, to write model input files.
```r
#-----------------------------------------------------------------------------#
#-- Settings
camels_dir <- "Your DIR here!"
gauge_info_path <- file.path(camels_dir,'basin_dataset_public_v1p2/basin_metadata/gauge_information.txt')
daymet_forcings <- file.path(camels_dir,'basin_dataset_public_v1p2/basin_mean_forcing/daymet')
flow_dir <- file.path(camels_dir,'basin_dataset_public_v1p2/usgs_streamflow')
bss <- 50 # Basin Subset "chunk" Size
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#-- Read in file to get a list of ALL gauges
gauges <- read.gaugeInfo(gauge_info_path)
allbasins <- gauges$gage_ID
#-----------------------------------------------------------------------------#

for (ibasin in 1:(ceiling(length(allbasins)/bss))) {
  print(paste('*----- Basin Subset', ibasin, 'of', ceiling(length(allbasins)/bss)))
  
  #-----------------------------------------------------------------------------#
  #-- Create subset of basins to conserve memory
  bstart <- (ibasin - 1) * bss + 1
  bend <- ibasin * bss
  if (bend > length(allbasins)) {bend <- length(allbasins)}
  basinSubset <- allbasins[bstart:bend]
  #-----------------------------------------------------------------------------#
  
  #-----------------------------------------------------------------------------#
  #-- Read in CAMELS files using caRmels functions
  
  #-- Basin files
  basinForcings_daymet <- importBasinForcings(daymet_forcings, dataset = 'daymet', subset=basinSubset)
  basinAttr <- importAttributes(folder = file.path('camels_attributes_v2.0')
  
  #-- Streamflows
  streamflows <- importStreamflows(flow_dir, subset = basinSubset)
  #-----------------------------------------------------------------------------#
  
  #-----------------------------------------------------------------------------#
  #-- Loop over subset basins
  print('* Looping over basins...')
  for (i in 1:length(basinSubset)) {
  
    basin_id <- basinSubset[i]
    basin_name <- trimws(gauges[gauges$gage_ID == basin_id, 'gage_name'])
    
    #... Code for individual basins, such as writing out model input files
    # Check out RavenR for file writing functions for the Raven Hydrological Modelling Framework!
    # https://cran.r-project.org/web/packages/RavenR/index.html
    # http://raven.uwaterloo.ca/RavenR.html

  }
}
```

## References
```
Addor, N., Newman, A. J., Mizukami, N., & Clark, M. P. (2017).
The CAMELS data set: catchment attributes and meteorology for large-sample studies.
Hydrol. Earth Syst. Sci, 21, 5293–5313. https://doi.org/10.5194/hess-21-5293-2017

Newman, A. J., Clark, M. P., Sampson, K., Wood, A., Hay, L. E., Bock, A., et al. (2015).
Development of a large-sample watershed-scale hydrometeorological data set for the
contiguous USA: data set characteristics and assessment of regional variability in 
hydrologic model performance. Hydrol. Earth Syst. Sci, 19, 209–223.
https://doi.org/10.5194/hess-19-209-2015
```
