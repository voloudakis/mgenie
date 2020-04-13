################################
# Predict the features for 1KG #
################################

############
# PARAMETERS
recipe.file        <- "PolyXcan_v1dbs_1kg.tsv"

####################
# PREPARING THE JOBS
library(data.table)
settings <- as.data.frame(fread(recipe.file)) # for compatibility
# Genotypes
dosages=settings[settings$name == "dosages", "value"]
dosages_prefix=settings[settings$name == "dosages_prefix", "value"]
samples=settings[settings$name == "samples", "value"]
# Weights
weights=settings[settings$name == "weights", "value"]
# Output
output_prefix_folder=settings[settings$name == "output_prefix_folder", "value"]
# Naming conversions
naming_conv_table=settings[settings$name == "naming_conv_table", "value"]
naming_conv_table = as.data.frame(fread(naming_conv_table))
# PrediXcan script
predixcan_exec=settings[settings$name == "predixcan_exec", "value"]
# Isoforms - remove isoforms from processing if applicable
isoforms=as.logical(settings[settings$name == "isoforms", "value"])
if (!isoforms) naming_conv_table = naming_conv_table[naming_conv_table$name != "isoforms",]

##################
# RUNNING THE JOBS
setwd(output_prefix_folder)
predixcan = paste0(
  #'conda activate py2',
  #' && ', # execult only if first one succeeded
  'python ', predixcan_exec, 
  ' --predict', 
  ' --dosages', ' ', dosages,
  ' --dosages_prefix' , ' ', dosages_prefix,
  ' --samples' , ' ', samples, 
  ' --weights' , ' ',  weights, '/', naming_conv_table$db_file,
  ' --output_prefix', ' ', output_prefix_folder,  naming_conv_table$name
  )
predixcan <- paste(c(predixcan, "wait"), collapse = " & ")
system(predixcan)
