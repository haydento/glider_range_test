# see the stan example on the reference website to investigate structure of functions
#https://github.com/wlandau/targets-stan/blob/main/R/utils.R
library(targets)
library(tarchetypes)
source("src/functions.R")
source("src/utils.R")

tar_option_set(packages = c("data.table", "leaflet", "rmarkdown", "sf", "glatos", "viridis", "leafem", "htmlwidgets", "leaflet.extras", "terra", "knitr", "rmarkdown", "geobuffer", "geosphere", "flextable"))
  
list(
  tar_target(
    raw_bathy,
    "data/LH_bathy/huron_lld.tif", # raw file for lake huron bathymetry data
    format = "file"
  ),
 ##  tar_target(
 ##    raw_lidar,
 ##    "data/Job654615_mi2013_usace_ncmp_lakehuron",
 ##    format = "file"
 ##  ),
 ## tar_target(
 ##   lidar,
 ##   lidar_prep(fls = raw_lidar, pth = "output/lidar.tif"), # prepares lidar data for use, combines tiles, fixes tile resolution
 ##   format = "file"
 ## ),
  tar_target(
    bathy,
    prep_bathy(raw_bathy, xmin_out = -84.288, xmax_out = -83.540, ymin_out = 45.438, ymax_out = 45.841), # writes output to ~/Documents/cisco_stocking_survival_pilot/plan_map/output/bathy.tif, preps bathy data for use later
    format = "file"
  ),
 tar_target(
   leaflet,
   leaflet_map(bathy, pth = "docs/index.html", lines = parallel_lines), #create leaflet map appropriate for webpage.  Also specify bridle length classes.
   format = "file"
 ),
 tar_target(
   parallel_lines,
   find_parallel_lines(start_lat = 45.537, start_lon = -83.999, offset = 500, line_direction = "N", parallel_line_direction = "E", inter_pt_dist = 500, line_dist = 2000),
   format = "fst_dt"
 )
 
)

#  tar_render(report, "src/rec_points_2021.rmd", output_dir = "output", output_file = "gear_deployment_coords.html"), # create html output of points

#  tar_target(
#    gear_gpx, # make gpx file for gear
#    make_gear_gpx(sentinal = sentinal_depth, receivers = all_rings, pth = "output/Sag_bay_cisco_deployments.gpx"),
#    format = "file"
#  ),

#  tar_target(
#    mobile_gpx, # make gpx file for mobile tracking
#    make_mobile_gpx(x = mob_depths, pth = "output/sag_bay_cisco_mobile.gpx"),
#    format = "file")
#)

  
  






