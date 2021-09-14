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

  tar_target(
    bathy,
    prep_bathy(raw_bathy, xmin_out = -84.288, xmax_out = -83.540, ymin_out = 45.438, ymax_out = 45.841), # writes output to ~/Documents/cisco_stocking_survival_pilot/plan_map/output/bathy.tif, preps bathy data for use later
    format = "file"
  ),

  tar_target(
   leaflet,
   leaflet_map(bathy, pth = "docs/index.html", lines = recs), #create leaflet map appropriate for webpage.  Also specify bridle length classes.
   format = "file"
 ),

 ## tar_target(
 ##   parallel_lines,
 ##   find_parallel_lines(start_lat = 45.537, start_lon = -83.999, offset = 500, line_direction = "E", parallel_line_direction = "N", inter_pt_dist = 500, line_dist = 2000),
 ##   format = "fst_dt"
 ## ),

 tar_target(
   parallel_lines,
   find_parallel_lines_split_start(start_lat = 45.5361667, start_lon = -84.00, split_dist = 250, bearing = 360-59.33614, end_lat = 45.545333, end_lon = -84.022, inter_pt_dist = 500),
   format = "fst_dt"
 ),
 
 tar_target(
   extract_depth,
   depth_extract(parallel_lines, bathy, lidar = NULL),
   format = "fst_dt"
 ),

 tar_target(
   recs,
   {gear <- data.table(glatos_array = c("MBU", "VPS"), gear_config = c("VR2W-180kHz, VR2Tx-69kHz, 180kHz tag, 69 kHz tag, temp logger", "VT2W-Tx 69 khz, mid water, sync tag active"));
     extract_depth[gear, config := gear_config, on = "glatos_array"]},
   format = "fst_dt"
 ),
 
 tar_render(report, "src/rec_points_2021.rmd", output_dir = "output", output_file = "output/gear_deployment_coords.html"), # create html output of points),

 tar_target(
   gpx,
   make_gpx(recs, pth = "output/glider_rec.gpx", idcol = "site"),
   format = "file"
 )
)



  
  


