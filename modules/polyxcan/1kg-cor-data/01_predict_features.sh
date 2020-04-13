#!/bin/bash

# This helper scripts allows to load the conda environment before loading R
# Within R system() call we cannot activate the environment
conda activate py2
Rscript 01_predict_features.R