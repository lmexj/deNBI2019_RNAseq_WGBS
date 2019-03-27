# Software installation 
## Go to CRAN repository to download R (version 3.5.3): https://cran.r-project.org/
## Go to Rstudio website to download the lastest version https://www.rstudio.com/products/rstudio/download/

## Note: package installation and loading are independent! You need to install new packages first!
## Then use library() function to load installed packages

# Day1 packages 
install.packages(c("plyr", "dplyr", "corrplot","rmarkdown", "knitr","devtools") )

# Day2 packages
install.packages("BiocManager") # for installing Bioconductor packages
install.packages(c("pheatmap","ggplot2", "stringi", "grid") )
BiocManager::install("DESeq2", version = "3.8")
BiocManager::install("biomaRt", version = "3.8")
BiocManager::install("vsn", version = "3.8")
BiocManager::install("IHW", version = "3.8")
BiocManager::install("apeglm", version = "3.8")
BiocManager::install("ComplexHeatmap", version = "3.8")

source("http://bioconductor.org/biocLite.R")
biocLite("hexbin")

# Day3 packages
install.packages(c("reshape2","data.table","ggrepel") )
BiocManager::install("bsseq", version = "3.8")
BiocManager::install("DSS", version = "3.8")
BiocManager::install("rtracklayer", version = "3.8")
