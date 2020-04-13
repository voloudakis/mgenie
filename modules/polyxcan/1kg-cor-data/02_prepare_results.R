#######################
# Prepare the results #
#######################

############
# PARAMETERS
recipe.file        <- "PolyXcan_v1dbs_1kg.tsv"

####################
# PREPARING THE JOBS
library(data.table)
settings <- as.data.frame(fread(recipe.file)) # for compatibility
# Output
output_prefix_folder=settings[settings$name == "output_prefix_folder", "value"]
# Naming conversions
naming_conv_table=settings[settings$name == "naming_conv_table", "value"]
naming_conv_table = as.data.frame(fread(naming_conv_table))
# Isoforms - remove isoforms from processing if applicable
isoforms=as.logical(settings[settings$name == "isoforms", "value"])
if (!isoforms) naming_conv_table = naming_conv_table[naming_conv_table$name != "isoforms",]

##################
# RUNNING THE JOBS
datasets <- naming_conv_table$name
dataset.files <- list.files(output_prefix_folder, full.names = T)
give_short_name <- function(x) {sub("_predicted_expression.txt", "", basename(x))}
prepare_datasets <- function(x) { # x is results_file
  short.name <- give_short_name(x)
  y <- fread(x)
  y <- y[,-1]
  y <- melt(y, id.vars = c("IID"))
  names(y)[3] <- "zscore"
  if (short.name == "genes") {
    names(y)[2] <- "geneId"
    y$data.type <- short.name
    y$gene <- ""
  } else {
    names(y)[2] <- "gene"
    y$data.type <- short.name
  }
  return(y)
}
library(pbmcapply)
results <- pbmclapply(dataset.files, FUN=prepare_datasets, mc.cores = detectCores()-1 )
names(results) <- give_short_name(dataset.files)
saveRDS(results, paste0(output_prefix_folder, "p02.1kg.eur.predict.melted.RDS"))


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
