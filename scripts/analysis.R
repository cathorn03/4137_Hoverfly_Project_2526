rm(list=ls())
# Ensure you have moved the vcftools fst output from HPC to working directory


setwd("~/Bioinformatics/Thesis") #Setting working directory
options(scipen = 999) #Sets plots to show numbers as none-scientific

# Load libraries
library(vcfR)
library(ggplot2)
library(viridis)
library(stringr)
library(dplyr)
library(plotly)
library(patchwork)
library(qqman)
library(readr)
library(dplyr)
library(tibble)
library(vcfR)
library(adegenet)
library(GenotypePlot)

#################
### FST Plots ###
#################

read_convert_main <- function(fst_file){ 
  # Reads in .fst files and converts the chromosome names to be linear numbers
  # fst_file (str) - the file and path of the fst file you want to read
  
  data <- read.table(fst_file, header = TRUE)  #Reads in the .fst file
  
  data$CHROM <- str_sub(data$CHROM, 4, -2) #Trims first and last characters from the chromosome name
  data$CHROM <- (as.numeric(data$CHROM) - 22139) #Subtracts number to get numerical chroms
  data$CHROM <- ifelse(data$CHROM == 6, "X", data$CHROM) #Sets Chromosome label from 6 to X
  data$CHROM <- paste("Chr", data$CHROM, sep = " ") #Adds Chr to all plot titles

  return(data) #Returns the .fst file as a df
}

read_convert_ragtag <- function(fst_file){ 
  # Reads in .fst files and converts the chromosome names to be linear numbers
  # fst_file (str) - the file and path of the fst file you want to read
  
  data <- read.table(fst_file, header = TRUE)  #Reads in the .fst file
  
  data$CHROM <- str_sub(data$CHROM, 4, -9) #Trims first and last characters from the chromosome name
  data$CHROM <- (as.numeric(data$CHROM) - 22139) #Subtracts number to get numerical chromosomes
  data$CHROM <- ifelse(data$CHROM == 6, "X", data$CHROM) #Sets Chromosome label from 6 to X
  data$CHROM <- paste("Chr", data$CHROM, sep = " ") #Adds Chr to all plot titles
  
  return(data) #Returns the .fst file as a df
}

fst_plot <- function(df, name){
  # Plots a multipanel fst plot of each chromosomes
  # df (data frame) - Contains the fst data
  # name (str) - Output name and path of the plot. Needs to contain image file extension
  
  plot <- ggplot(data = df, aes(x = BIN_START, y = WEIGHTED_FST)) + #Plots BIN_START against WEIGHTED_FST
  geom_point(size = 0.6, alpha = 0.3) + #Sets size and opacity of the points
  facet_wrap(vars(CHROM), scales = "free_x") + #Makes the x-axis of each plot independant
  labs(x = "Position", y = "Weighted Fst") + #Adds axis labels
  ylim(-0.1, 1) #Sets y-axis size and limits
  plot
  ggsave(name, height = 5, width = 10) #Saves the output
}

get_bed <- function(data, out_file, threshold){
  # Produces a .bed file containing the windows with a mean fst greater than a given threshold
  # fst_file (str) - The file name and path of the .fst file you want to ge the .bed file from
  # threshold (float) - The threshold of fst you want to chech for
  # out_file (strin) - Name and path of the file to be outputted
  
  data <- read.table(data, header = TRUE) #Reads in fst data
  
  #data$CHROM <- str_sub(data$CHROM, 4, -2) #Trims first and last characters from the chromosome name
  #data$CHROM <- (as.numeric(data$CHROM) - 22139) #Subtracts number to get numerical chroms
  #data$CHROM <- ifelse(data$CHROM == 6, "X", data$CHROM)
  
  threshold <- quantile(data$MEAN_FST, probs = 0.99, na.rm = TRUE)

  thres_data <- data %>% filter(MEAN_FST > threshold) #Filters for windows with mean fst above a given threshold
  out <- thres_data %>% select(CHROM, BIN_START, BIN_END) #Slects just these coloumns (coordinate data)
  write_tsv(out, file = out_file, col_names=FALSE) #Writes out the file
}

percentile <- function(data, percent){
  threshold <- quantile(data$WEIGHTED_FST, probs = percent, na.rm = TRUE)
  return(data %>% filter(WEIGHTED_FST > threshold))
}

# Reading in the different FST data which used different window and step sizes
ref_50k <- read_convert_main("./haplotype_1/FST_80b/50k.windowed.weir.fst")
alt_50k <- read_convert_ragtag("./haplotype_2/FST_80b/50k.windowed.weir.fst")
plu_50k <- read_convert_ragtag("./haplotype_3/FST_80b/50k.windowed.weir.fst")
bom_50k <- read_convert_ragtag("./haplotype_4/FST_80b/50k.windowed.weir.fst")

#Provides summary inforamtion for the FST data of each assembly
summary(ref_50k)
summary(alt_50k)
summary(plu_50k)
summary(bom_50k)

# Plotting the different FST data which used different window and step sizes
fst_plot(main_50k, "./haplotype_1/FST_80b/50k.png")
fst_plot(alt_50k, "./haplotype_2/FST_80b/50k.png")
fst_plot(plu_50k, "./haplotype_3/FST_80b/50k.png")
fst_plot(bom_50k, "./haplotype_4/FST_80b/50k.png")

#Returns onlhy windows in the 99th percentile of weighted FST
ref99 <- percentile(ref_50k, 0.99)
alt99 <- percentile(alt_50k, 0.99)
plu99 <- percentile(plu_50k, 0.99)
bom99 <- percentile(bom_50k, 0.99)

######################
### Genotype Plots ###
######################

gt_plot <- function(VCF, CHR, START, END, POPMAP){
  #Produces a genotype plot for a provided vcf file
  #VCF (str) - file path and name of the selected VCF file
  #CHR (str) - Name of chromsome in VCF file the region of interest is on
  #START (num) - Starting coordinate of the region of interest
  #END (num) - Ending coordinate of the region of interest
  #POPMAP (df) - A data frame containing sample names and their population identifier
  
  #Runs geontype plot with provided args,
  gtplt <- genotype_plot(vcf = VCF
                            chr = CHR,,
                            start = START,
                            end = END,
                            popmap = POPMAP,                              
                            cluster        = FALSE,                           
                            snp_label_size = 10000, #Sets size of labels                      
                            colour_scheme=c("#FCD225","#C92D59","#300060"), #Sets colour of plot 
                            invariant_filter = TRUE)
  
  return(gtplt) #Returns plot from function
}

#Creates population maps for gtplot (POPMAP)
ref_popmap <- read.table("./pop_maps/ref_popmap.tsv", header = TRUE)
alt_popmap <- read.table("./pop_maps/alt_popmap.tsv", header = TRUE)
plu_popmap <- read.table("./pop_maps/plu_popmap.tsv", header = TRUE)
bom_popmap <- read.table("./pop_maps/bom_popmap.tsv", header = TRUE)

#Runs gtplot for ROI on chromosome 1
ref_10M <- gt_plot("./haplotype_1/VB.chr1.10M.vcf.gz",     "OX422140.1",        10200001, 10310000, ref_popmap)
alt_10M <- gt_plot("./haplotype_2/alt_VB.10M.vcf.gz",      "OX422140.1_RagTag", 10433500, 10436000, alt_popmap)
plu_10M <- gt_plot("./haplotype_3/plu_VB.chr1.10M.vcf.gz", "OX422140.1_RagTag", 10401800, 10403300, plu_popmap)
bom_10M <- gt_plot("./haplotype_4/bom_VB.chr1.10M.vcf.gz", "OX422140.1_RagTag", 9960001,  10030000, bom_popmap)

#Shows plots for chromsome 1 ROi
ref_10M
alt_10M
plu_10M
bom_10M

#Saves plots for chromosome 1 ROI
png("./Genotype_plots/ref_10M.png", width=500)
combine_genotype_plot(ref_10M)
dev.off()
png("./Genotype_plots/alt_10M.png", width=500)
combine_genotype_plot(alt_10M)
dev.off()
png("./Genotype_plots/plu_10M.png", width=500)
combine_genotype_plot(plu_10M)
dev.off()
png("./Genotype_plots/bom_10M.png", width=500)
combine_genotype_plot(bom_10M)
dev.off()

#Below is the running gtplot for all the identified ROI on each chromosome, and subsequent rendering of their plots
ref_30M <- gt_plot("./haplotype_1/VB.chr1.30M.vcf.gz",     "OX422140.1",        129080001, 129300000, ref_popmap)
alt_30M <- gt_plot("./haplotype_2/alt_VB.chr1.30M.vcf.gz", "OX422140.1_RagTag", 138230001, 139320000, alt_popmap)
plu_30M <- gt_plot("./haplotype_3/plu_VB.chr1.30M.vcf.gz", "OX422140.1_RagTag", 132040001, 132460000, plu_popmap)
bom_30M <- gt_plot("./haplotype_4/bom_VB.chr1.30M.vcf.gz", "OX422140.1_RagTag", 138230001, 139320000, bom_popmap)

ref_130M
alt_130M
plu_130M
bom_130M

ref_130M <- gt_plot("./haplotype_1/VB.chr1.125-150.vcf.gz",     "OX422140.1",        129000001, 129300000, ref_popmap)
alt_130M <- gt_plot("./haplotype_2/alt_VB.chr1.125-150.vcf.gz", "OX422140.1_RagTag", 138230001, 139320000, alt_popmap)
plu_130M <- gt_plot("./haplotype_3/plu_VB.chr1.125-150.vcf.gz", "OX422140.1_RagTag", 131900001, 132500000, plu_popmap)
bom_130M <- gt_plot("./haplotype_4/bom_VB.chr1.125-150.vcf.gz", "OX422140.1_RagTag", 138230001, 139320000, bom_popmap)

ref_130M
alt_130M
plu_130M
bom_130M

ref_chr2_65M <- gt_plot("./haplotype_1/VB.chr2.65M.vcf.gz",     "OX422141.1",        60280001, 60530000, ref_popmap)
alt_chr2_65M <- gt_plot("./haplotype_2/alt_VB.chr2.65M.vcf.gz", "OX422141.1_RagTag", 60280001, 60530000, alt_popmap)
plu_chr2_65M <- gt_plot("./haplotype_3/plu_VB.chr2.65M.vcf.gz", "OX422141.1_RagTag", 52870001, 61150000, plu_popmap)
bom_chr2_65M <- gt_plot("./haplotype_4/bom_VB.chr2.65M.vcf.gz", "OX422141.1_RagTag", 60280001, 60530000, bom_popmap)

ref_chr2_65M
alt_chr2_65M
plu_chr2_65M
bom_chr2_65M

ref_chr3_67M <- gt_plot("./haplotype_1/VB.chr3.67M.vcf.gz",     "OX422142.1",        52720001, 53080000, ref_popmap)
alt_chr3_67M <- gt_plot("./haplotype_2/alt_VB.chr3.67M.vcf.gz", "OX422142.1_RagTag", 52720001, 53080000, alt_popmap)
plu_chr3_67M <- gt_plot("./haplotype_3/plu_VB.chr3.67M.vcf.gz", "OX422142.1_RagTag", 52720001, 53080000, plu_popmap)
bom_chr3_67M <- gt_plot("./haplotype_4/bom_VB.chr3.67M.vcf.gz", "OX422142.1_RagTag", 52720001, 53080000, bom_popmap)

ref_chr3_67M
alt_chr3_67M
plu_chr3_67M
bom_chr3_67M

ref_chr4_162M <- gt_plot("./haplotype_1/VB.chr4.162M.vcf.gz",     "OX422143.1",        166760001, 167200000, ref_popmap)
alt_chr4_162M <- gt_plot("./haplotype_2/alt_VB.chr4.162M.vcf.gz", "OX422143.1_RagTag", 170840001, 171110000, alt_popmap)
plu_chr4_162M <- gt_plot("./haplotype_3/plu_VB.chr4.175M.vcf.gz", "OX422143.1_RagTag", 177680001, 177890000, plu_popmap)
bom_chr4_162M <- gt_plot("./haplotype_4/bom_VB.chr4.162M.vcf.gz", "OX422143.1_RagTag", 170880001, 170990000, bom_popmap)

ref_chr4_162M
alt_chr4_162M
plu_chr4_162M
bom_chr4_162M

plu_chr5_50M <- gt_plot("./haplotype_3/plu_VB.chr5.50M.vcf.gz", "OX422144.1_RagTag", 39240001, 40140000, plu_popmap)
bom_chr5_50M <- gt_plot("./haplotype_4/bom_VB.chr5.50M.vcf.gz", "OX422144.1_RagTag", 70350001, 70920000, bom_popmap)
plu_chr5_50Mb <- gt_plot("./haplotype_3/plu_VB.chr5.50M.vcf.gz", "OX422144.1_RagTag", 70350001, 70920000, plu_popmap)
bom_chr5_50Mb <- gt_plot("./haplotype_4/bom_VB.chr5.50M.vcf.gz", "OX422144.1_RagTag", 39240001, 40140000, bom_popmap)

plu_chr5_50M
bom_chr5_50M
plu_chr5_50Mb
bom_chr5_50Mb

ref_chr6_10M <- gt_plot("./haplotype_1/VB.chr6.10M.vcf.gz", "OX422145.1", 12150001, 12320000, ref_popmap)
alt_chr6_10M <- gt_plot("./haplotype_2/alt_VB.chr6.10M.vcf.gz", "OX422145.1_RagTag", 20250001, 20500001, alt_popmap)
plu_chr6_10M <- gt_plot("./haplotype_3/plu_VB.chr6.10M.vcf.gz", "OX422145.1_RagTag", 16580001, 16780000, plu_popmap)
bom_chr6_10M <- gt_plot("./haplotype_4/bom_VB.chr6.10M.vcf.gz", "OX422145.1_RagTag", 8230001, 8310000, bom_popmap)

ref_chr6_10M
alt_chr6_10M
plu_chr6_10M
bom_chr6_10M

####################
### PCA from VCF ###
####################

plot_pca <- function(vcf_file, covar){
  #Carries out PCA on a provided VCF file and produces a PCA plot
  #vcf_file (str) - Path to, and name of chosen VCF file
  #covar (str) - Path to, and name of covariate file for the assebmly as a .csv file
  
  vcf <- read.vcfR(vcf_file) #Reads VCF file
  mat <- extract.gt(vcf) #Extracts genotype matrix
  mat <- t(mat) #Transposes matrix
  colnames(mat) <- gsub("\\.", "_", colnames(mat)) #Replaces "." in columns with "_"
  gen <- df2genind(mat, sep = "/") #Converts matrix into genind object with "/" as allele separaters
  gen <- df2genind(mat, sep = "/", ind.names(row.names(mat))) # Convert the genotype matrix into a genind object again while using row names as individual names
  
  allele_freq <- tab(gen, freq = T, NA.method = "mean") #Calculate allele frequencies for each marker
  
  pca <- dudi.pca(allele_freq, center = T, scale = F, scannf = FALSE, nf = 2) 
  #Perform PCA on the allele-frequency data
  #Each variable centered around its mean
  #Variables are not standardised by their standard deviation
  #Scree lot not displayed interactovely
  
  pca_scores <- pca$li #Extracts PCA scroes for each individual
  pca_scores$Individual <- row.names(pca_scores) #Adds indivdual names as a columns
  ptcv <- read.csv(covar) #Reads covariate file
  merged_pca_data <- merge(pca_scores, ptcv, by = "Individual") #Merges PCA score with column based on individual name
  var_exp <- (pca$eig / sum(pca$eig)) * 100 #Calculates percentage total variance for each PC
  
  ggplot(data = merged_pca_data, aes(x = Axis1, y = Axis2, colour = pop))+ #Plots PCA. Points are coloured by their population
    geom_point(size = 2.5) + #Sets point size
    labs(
      x = paste0("PC1 (", round(var_exp[1], 1), "%)"), #Labels x-axis and adds variance explained
      y = paste0("PC2 (", round(var_exp[2], 1), "%)"), #Labels y-axis and adds variance explained
      color = "Population") #Adds a label to the key
}

#Running of plot_pca of the chromsome 1 ROI
ref_10M_pca <- plot_pca("./haplotype_1/VB.10m.region.vcf.gz", "./covariates/ref_covar.csv")
alt_10M_pca <- plot_pca("./haplotype_2/alt_VB.chr1.10M.region.vcf.gz", "./covariates/alt_covar.csv")
plu_10M_pca <- plot_pca("./haplotype_3/plu_VB.10m.region.vcf.gz", "./covariates/plu_covar.csv")
bom_10M_pca <- plot_pca("./haplotype_4/bom_VB.10m.region.vcf.gz", "./covariates/bom_covar.csv")

#Rendering and saving of chromsome 1 PCA plots
ref_10M_pca
alt_10M_pca
ggsave("./PCA_plots/alt_10M.png")
plu_10M_pca
ggsave("./PCA_plots/plu_10M.png")
bom_10M_pca

#Below is the running of plot_pca for potential candidate regions identified by gt_plot, and subsequent rendering of ther plots
ref_chr2_65M_pca <- plot_pca("./haplotype_1/plu_VB.chr2.65M.region.vcf.gz", "./covariates/ref_covar.csv")
alt_chr2_65M_pca <- plot_pca("./haplotype_2/alt_VB.chr2.65M.region.vcf.gz", "./covariates/alt_covar.csv")
plu_chr2_65M_pca <- plot_pca("./haplotype_3/plu_VB.chr2.65M.region.vcf.gz", "./covariates/plu_covar.csv")
bom_chr2_65M_pca <- plot_pca("./haplotype_4/bom_VB.chr2.65M.region.vcf.gz", "./covariates/bom_covar.csv")

ref_chr2_65M_pca
alt_chr2_65M_pca
plu_chr2_65M_pca
bom_chr2_65M_pca

ref_chr3_67M_pca <- plot_pca("./haplotype_1/VB.chr3.67M.vcf.gz",     "./covariates/ref_covar.csv")
alt_chr3_67M_pca <- plot_pca("./haplotype_2/alt_VB.chr3.67M.vcf.gz", "./covariates/alt_covar.csv")
plu_chr3_67M_pca <- plot_pca("./haplotype_3/plu_VB.chr3.67M.vcf.gz", "./covariates/plu_covar.csv")
bom_chr3_67M_pca <- plot_pca("./haplotype_4/bom_VB.chr3.67M.vcf.gz", "./covariates/bom_covar.csv")

ref_chr4_162M_pca <- plot_pca("./haplotype_1/VB.chr4.162M.vcf.gz",     "./covariates/alt_covar.csv")
alt_chr4_162M_pca <- plot_pca("./haplotype_2/alt_VB.chr4.162M.vcf.gz", "./covariates/ref_covar.csv")
plu_chr4_175M_pca <- plot_pca("./haplotype_3/plu_VB.chr4.175M.region.vcf.gz", "./covariates/plu_covar.csv")
bom_chr4_162M_pca <- plot_pca("./haplotype_4/bom_VB.chr4.162M.vcf.gz", "./covariates/bom_covar.csv")
plu_chr4_175M_pca


plu_chr5_50m_pca <- plot_pca("./haplotype_3/plu_VB.chr5.50M.region.vcf.gz", "./covariates/plu_covar.csv")
bom_chr5_50m_pca <- plot_pca("./haplotype_4/bom_VB.chr5.50M.region.vcf.gz", "./covariates/bom_covar.csv")

plu_chr5_50m_pca
bom_chr5_50m_pca

plu_chr5_50m_pcab <- plot_pca("./haplotype_3/plu_VB.chr5.50M.regionb.vcf.gz", "./covariates/plu_covar.csv")
bom_chr5_50m_pcab <- plot_pca("./haplotype_4/bom_VB.chr5.50M.regionb.vcf.gz", "./covariates/bom_covar.csv")

plu_chr5_50m_pcab
bom_chr5_50m_pcab

plu_chr6_10M_pca <- plot_pca("./haplotype_3/plu_VB.chr6.10M.region.vcf.gz", "./covariates/plu_covar.csv")
plu_chr6_10M_pca

bom_chr2_60M_pca <- plot_pca("./haplotype_4/bom_VB.chr2.60M.region.vcf.gz", "./covariates/bom_covar.csv")
bom_chr2_60M_pca
