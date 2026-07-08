#!/usr/bin/env Rscript

if (!require("dplyr")) install.packages("dplyr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("ggpubr")) install.packages("ggpubr")
if (!require("plotly")) install.packages("plotly")
if (!require("readr")) install.packages("readr")
if (!require("stringr")) install.packages("stringr")
if (!require("qqman")) install.packages("qqman")

library(stringr)
library(dplyr)
library(plotly)
library(patchwork)
library(qqman)
library(readr)
library(dplyr)

setwd("/share/hoverflies/Caleb/haplotype_1")

read_make_manhattan <- function(file_name, image_name){
  df <- read.table(file_name, header = TRUE) #Reads in GWAS file
  
  df$CHR <- str_sub(df$CHR, 4, -2) 
  df$CHR <- (as.numeric(df$CHR) - 22139)
  #Makes chromosomes readable
  
  df <- select(df, c("SNP","CHR","BP","P"))
  #Makes a DF of just important parts
  df <- df[is.finite(df$P) & df$P > 0, ]
  
  png(image_name,res=600, width=4800, height=3244)
  plt <- manhattan(df)
  plt
  dev.off()
}

read_make_manhattan("./plink/GWAS_PCA3.assoc.logistic", "./plink/GWAS_PCA3.png")