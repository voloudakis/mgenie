#!/bin/env Rscript

### * arguments
args <- commandArgs(trailingOnly = TRUE)
expr.file <- args[1]
covar.file <- args[2]
out.file <- args[3]
genebatch.file <- args[4]
### * libraries
library(data.table)
library(doParallel)
library(parallel)
library(RcmdrMisc)
library(ggplot2)
### * read files
genebatch <- readLines(genebatch.file)
expr <- readRDS(expr.file)
expr <- expr[,genebatch]
covar <- fread(covar.file)


### * custom functions
### ** bicassoc: stewise from RcmdrMisc
bicassoc.nobase <- function(df,gene,covar.names){
  fm <- as.formula(paste0(gene,"~",paste0(covar.names,collapse="+")))
  m <- lm(fm,data=df)
  m1 <- stepwise(m,criterion="BIC", direction = "forward", trace=FALSE)
  res <- paste0(m1$call$formula)[3]
  return(data.frame(gene=gene,model=res, stringsAsFactors = FALSE))
}
### ** bicassoc:
bicassoc <- function(df,gene,covar.names,basevars){
  fm.upper <- as.formula(paste0(gene,"~",paste0(covar.names,collapse="+")))
  fm.lower <- as.formula(paste0(gene,"~",paste0(basevars,collapse = "+")))
  print(fm.upper)
  print(fm.lower)
  m <- lm(fm.upper,data=df)
  m1 <- step(m,scope=list(lower=fm.lower,upper=fm.upper), k=log(nrow(df)),
             direction = "forward", trace=FALSE)
  res <- paste0(m1$call$formula)[3]
  return(data.frame(gene=gene,model=res, stringsAsFactors = FALSE))
}

### ** aicassoc:
aicassoc <- function(df,gene,covar.names,basevars){
  fm.upper <- as.formula(paste0(gene,"~",paste0(covar.names,collapse="+")))
  fm.lower <- as.formula(paste0(gene,"~",paste0(basevars,collapse = "+")))
  print(fm.upper)
  print(fm.lower)
  m <- lm(fm.upper,data=df)
  m1 <- step(m,scope=list(lower=fm.lower,upper=fm.upper))
  res <- paste0(m1$call$formula)[3]
  return(data.frame(gene=gene,model=res, stringsAsFactors = FALSE))
}

### ** bicassoc.try: assoc
bicassoc.try <- function(gene1=gene,...){
  tryCatch({
    bicassoc(...)
  },
  error = function(e){
    return(data.frame(gene=gene1, model=paste(e),
                      stringsAsFactors = FALSE))
  })
}
### ** bicassoc.try: assoc
aicassoc.try <- function(gene1=gene,...){
  tryCatch({
    aicassoc(...)
  },
  error = function(e){
    return(data.frame(gene=gene1, model=paste(e),
                      stringsAsFactors = FALSE))
  })
}
### * script
### ** convert expr matrix to data table
genes <- colnames(expr)
ids <- rownames(expr)
expr <- data.table(expr)
expr$id <- ids
### ** dummy names for covar
covar.names <- names(covar)
covar.names <- covar.names[!covar.names %in% "id"]
##covar.dummy.names <- paste0("Cov",1:length(covar.names))
##covar.df <- data.frame(covar.names = covar.names, dummy = covar.dummy.names,
##                       stringsAsFactors = FALSE)
##names(covar) <- c("id",covar.df$dummy)
### ** merge with covariate file
df <- merge(expr,covar,by="id")
### ** assoc
res <- list()
system.time(res <- lapply(genes,function(x) bicassoc.nobase(df,x,covar.names)))

res <- data.table(do.call(rbind,res))
names(res) <- c("gene","bestModel")
fwrite(res,out.file)

### ** plot the models
##model.split <- split(res, by="bestModel")
##models.plot <- ggplot(res,aes())

### * org mode specific
### Local Variables:
### eval: (orgstruct-mode 1)
### orgstruct-heading-prefix-regexp: "### "
### End:
